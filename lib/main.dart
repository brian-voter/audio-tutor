import 'dart:convert';
import 'dart:io';

import 'package:audio_tutor/buffer_audio_source.dart';
import 'package:audio_tutor/frequency.dart';
import 'package:audio_tutor/text_to_speech.dart';
import 'package:audio_tutor/transcript.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audio_tutor/dictionary.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:hive_flutter/adapters.dart';

import 'MainPage.dart';
import 'at_audio_player.dart';
import 'config.dart';
import 'config_ui.dart';

const seekTimeMs = 5000; //TODO: migrate to config setting
const chineseLangTtsTagAndroid = "cmn_TW";
const chineseLangTtsTagWeb = "zh-TW";
const englishTtsTag = "en-US";

late final Box<Config> configsBox;
late final Box mainBox;

//TODO: migrate dictionary etc out of homepage so it loads faster when we navigate to it

//TODO: actually use these:
class PageIndices {
  static const int audioPlayerhome = 0;
  static const int configEditor = 1;
}

void main() async {
  await _initConfig();
  runApp(const MyApp());
}

_initConfig() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ConfigAdapter());
  configsBox = await Hive.openBox("configs");
  mainBox = await Hive.openBox("main");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ting - Chinese Audio Tutor',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainPage(),
    );
  }
}

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});
  static const String routeName = "/home";

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> with AutomaticKeepAliveClientMixin {
  late final ATAudioPlayer _player;
  late final MethodChannel platformMethodChannel;
  late final TTSImpl _ttsImpl;
  late final Dictionary _dict;
  late final FrequencyList _freqList;
  late Transcript _srt;
  late Config config;
  bool _started = false;
  bool _playing = false;
  int? _queryingAtWordIndex;
  String _currentlyDisplayedDefText = "";
  String _currentlyDisplayedSubLineText = "";
  Duration? _audioPosition;
  Duration? _totalDuration;
  bool _isCaptureVolumeButtons = true;
  bool _audioReady = false;
  bool _srtReady = false;
  double _queryPositionOffsetMs = -700.0;

  _AudioPlayerPageState() {
    init();
  }

  void init() async {
    await loadConfig();

    final dictStr = await rootBundle.loadString("assets/cedict_ts.txt");
    _dict = Dictionary(dictStr);

    //TODO: fix frequency list to work with traditional chars as well
    final freqStr = await rootBundle.loadString("assets/freq_list.txt");
    _freqList = FrequencyList(freqStr);

    _ttsImpl = TTSImpl(_onTTSSpeechComplete);

    platformMethodChannel =
        const MethodChannel('com.chrono7.audiotutor/volumeservice');
    platformMethodChannel.setMethodCallHandler(_methodCallHandler);

    updateVolumeCaptureStatus();
  }

  Future<void> loadConfig() async {
    //TODO change this to be the user specified default
    String activeConfigName = mainBox.get("activeConfig", defaultValue: "default");

    config = configsBox.get(activeConfigName, defaultValue: Config())!;
    config.save();

    print(config.configName);
  }

  void updateVolumeCaptureStatus() {
    if (!kIsWeb && Platform.isAndroid) {
      if (_isCaptureVolumeButtons) {
        platformMethodChannel.invokeMethod("enableVolumeCapture");
      } else {
        platformMethodChannel.invokeMethod("disableVolumeCapture");
      }
    }
  }

  Future<void> _methodCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onVolumeButtonPress":
        if (call.arguments == 1) {
          _queryMoveFoward();
        } else if (call.arguments == -1) {
          _queryMoveBack();
        } else {
          _consultDict();
        }
        break;
      default:
        print("ERROR: no method handler for ${call.method}");
    }
  }

  void _onTTSSpeechComplete() {
    _playing = true;
    _player.play();
  }

  Future<void> _initPlayer() async {
    // https: //www.youtube.com/watch?v=jRh7Pyq1z1A&list=PLfS0WrMWEu_73gUisyRvzIFyJ6I5RFszh
    // await _player.setSource(AssetSource("laogao_audio.mp3"));
    // await _player.setSourceDeviceFile("/sdcard/Documents/Socrates.mp3");
    _player.getPositionStream().listen(_onPlayerPositionChanged);
    _player.getDurationStream().listen(_onPlayerDurationChanged);
    // _player.onPositionChanged.listen(_onPlayerPositionChanged);
    // _player.onDurationChanged.listen(_onPlayerDurationChanged);
    final duration = (await _player.getDuration()) ?? const Duration();
    setState(() {
      _totalDuration = duration;
      _audioReady = true;
    });
  }

  void _onCaptureVolumeButtonsChanged(bool captureEnabled) {
    setState(() {
      _isCaptureVolumeButtons = captureEnabled;
      updateVolumeCaptureStatus();
    });
  }

  void _onPlayerPositionChanged(Duration? position) {
    setState(() {
      _audioPosition = position;
    });
  }

  void _onPlayerDurationChanged(Duration? duration) {
    setState(() {
      _totalDuration = duration;
    });
  }

  void _pause() {
    _player.pause();
    setState(() {
      _playing = false;
    });
  }

  void _readDefinitionTTS(DictionaryEntry entry) {
    if (!kIsWeb && Platform.isAndroid) {
      platformMethodChannel.invokeMethod("setWakeLock");
    }

    final toSay = [
      TtsItem(
          entry.tradHanzi,
          // (kIsWeb ? chineseLangTtsTagWeb : chineseLangTtsTagAndroid)),
          config.ttsChineseLocale, Voice(config.ttsChineseVoice, config.ttsChineseLocale)),
      TtsItem(entry.definition.replaceAll("/", ";"),
          config.ttsEnglishLocale, Voice(config.ttsEnglishVoice, config.ttsEnglishLocale))
    ];

    _ttsImpl.interruptAndScheduleBatch(toSay);
  }

  void _renderQuery(SubtitleWord queryWord) {
    final word = queryWord.text;

    final entry = _dict.lookup(word);
    final String def =
        entry?.getFullEntryString() ?? "$word: no definition found :(";

    setState(() {
      _currentlyDisplayedSubLineText =
          _srt.getLineAtIndex(queryWord.lineIndex).text;
      _currentlyDisplayedDefText = def;
    });

    if (entry != null) {
      _readDefinitionTTS(entry);
    }
  }

  Future<void> _consultDict() async {
    if (!_started) {
      return;
    }

    _pause();

    final positionSeconds =
        (await _player.getPosition() ?? const Duration()).inSeconds.toDouble();

    //TODO: catch in case of out of bounds
    var queryingWord =
        _srt.getWordAtTime(positionSeconds + (_queryPositionOffsetMs / 1000));
    _queryingAtWordIndex = queryingWord.wordIndex;
    var freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);

    while (freq < config.ignoreWordsBelowFrequency) {
      _queryingAtWordIndex = _queryingAtWordIndex! - 1;
      queryingWord = _srt.getWordAtIndex(_queryingAtWordIndex!);
      freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);
    }

    _renderQuery(queryingWord);
  }

  void _queryMoveBack() {
    if (_playing) {
      _consultDict();
      return;
    }

    if (_queryingAtWordIndex == null || _queryingAtWordIndex! <= 0) {
      return;
    }

    //TODO: handle out of bounds!
    _queryingAtWordIndex = _queryingAtWordIndex! - 1;
    var queryingWord = _srt.getWordAtIndex(_queryingAtWordIndex!);
    var freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);

    while (freq < config.ignoreWordsBelowFrequency) {
      _queryingAtWordIndex = _queryingAtWordIndex! - 1;
      queryingWord = _srt.getWordAtIndex(_queryingAtWordIndex!);
      freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);
    }
    _renderQuery(queryingWord);
  }

  void _queryMoveFoward() {
    if (_playing) {
      _consultDict();
      return;
    }

    if (_queryingAtWordIndex == null || _queryingAtWordIndex! <= 0) {
      return;
    }

    //TODO: handle out of bounds!
    _queryingAtWordIndex = _queryingAtWordIndex! + 1;
    var queryingWord = _srt.getWordAtIndex(_queryingAtWordIndex!);
    var freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);

    while (freq < config.ignoreWordsBelowFrequency) {
      _queryingAtWordIndex = _queryingAtWordIndex! + 1;
      queryingWord = _srt.getWordAtIndex(_queryingAtWordIndex!);
      freq = _freqList.getFreqOrDefault(queryingWord.text, 100000);
    }
    _renderQuery(queryingWord);
  }

  void _stopTts() {
    _ttsImpl.stopAndClearScheduled();
  }

  void _playPauseButtonPress() {
    _started = true;

    setState(() {
      _playing = !_playing;
    });

    if (_playing) {
      _stopTts();
      _player.play();
    } else {
      _player.pause();
    }
  }

  void _onUserSeek(Duration seekPos) {
    _player.seek(seekPos);
  }

  void _onBackButtonPress() async {
    final curPos = await _player.getPosition();

    if (curPos == null) {
      return;
    }

    _player.seek(Duration(milliseconds: (curPos.inMilliseconds) - seekTimeMs));
  }

  void _onForwardButtonPress() async {
    final curPos = await _player.getPosition();

    if (curPos == null) {
      return;
    }

    _player.seek(Duration(milliseconds: (curPos.inMilliseconds) + seekTimeMs));
  }

  void _onSelectAudioFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["mp3"]);

    if (result != null) {
      if (kIsWeb) {
        //TODO: make async so we don't bog down UI!
        _player = await JAAudioPlayerImpl.build(
            BufferAudioSource(result.files.single.bytes!));
      } else {
        _player = await APAudioPlayerImpl.build(result.files.single.path!);
      }
      // _player.setAudio
      // _player.setAudioSource(AudioSource)
      // await _player.setSourceDeviceFile(result.files.single.path!);
      // await _player.setSourceBytes(result.files.single.bytes!);
      _initPlayer();
      // _initVolumeWatcher();
    }
  }

  void _onSelectSRTFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["srt"]);

    if (result != null) {
      if (kIsWeb) {
        final str =
            const Utf8Decoder().convert(result.files.single.bytes!.toList());
        _srt = Transcript(str, _dict);
      } else {
        File file = File(result.files.single.path!);
        _srt = Transcript(file.readAsStringSync(), _dict);
      }
      _srtReady = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              // IMPORT & SETTINGS
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    IconButton(
                        onPressed: _onSelectAudioFile,
                        icon: const Icon(Icons.file_open)),
                    const Text("Select Audio File"),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: _onSelectSRTFile,
                        icon: const Icon(Icons.file_open)),
                    const Text("Select SRT File"),
                  ],
                ),
                ((!kIsWeb && Platform.isAndroid)
                    ? Row(
                        //TODO: refactor this mess
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Switch(
                                  value: _isCaptureVolumeButtons,
                                  onChanged: _onCaptureVolumeButtonsChanged),
                              const Text("Capture vol. buttons"),
                            ],
                          ),
                        ],
                      )
                    : Row()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Offset (ms):"),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Container(
                          constraints: const BoxConstraints.expand(
                              width: 200, height: 40),
                          child: SpinBox(
                            min: -60000,
                            max: 60000,
                            value: _queryPositionOffsetMs,
                            step: 100,
                            onChanged: (value) => {
                              setState(() {
                                _queryPositionOffsetMs = value;
                              })
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentlyDisplayedSubLineText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _currentlyDisplayedDefText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed:
                          (_started && _srtReady) ? _queryMoveBack : null,
                      child: const Icon(Icons.arrow_back)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed:
                            (_started && _srtReady) ? _consultDict : null,
                        child: const Icon(Icons.search)),
                  ),
                  ElevatedButton(
                      onPressed:
                          (_started && _srtReady) ? _queryMoveFoward : null,
                      child: const Icon(Icons.arrow_forward)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: ProgressBar(
                  progress: _audioPosition ?? const Duration(seconds: 0),
                  buffered: const Duration(seconds: 0),
                  total: _totalDuration ?? const Duration(seconds: 0),
                  onSeek: _onUserSeek,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: _started ? _onBackButtonPress : null,
                      child: const Icon(Icons.keyboard_double_arrow_left)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: _audioReady ? _playPauseButtonPress : null,
                        child: Icon(_playing ? Icons.pause : Icons.play_arrow)),
                  ),
                  ElevatedButton(
                      onPressed: _started ? _onForwardButtonPress : null,
                      child: const Icon(Icons.keyboard_double_arrow_right)),
                ],
              ),
              //     child: Text(
              //   playing ? "Pause" : "Play"
              // )),
            ])
          ],
        ),
    );
  }

  @override
  // TODO: fix this?
  bool get wantKeepAlive => true;
}

//43:22 被
//44:07 就
