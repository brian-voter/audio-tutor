import 'dart:io';

import 'package:audio_tutor/text_to_speech.dart';
import 'package:audio_tutor/transcript.dart';
import 'package:audio_tutor/utils.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:audio_tutor/dictionary.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:volume_watcher/volume_watcher.dart';

const seekTimeMs = 5000;

void main() {
  runApp(const MyApp());
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
      home: const MyHomePage(title: 'Ting - Chinese Audio Tutor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _player = AudioPlayer();
  bool _started = false;
  bool _playing = false;
  int? _queryingAtWordIndex;
  late Dictionary _dict;
  late Transcript _srt;
  String _currentlyDisplayedDefText = "";
  String _currentlyDisplayedSubLineText = "";
  late final TTSImpl _ttsImpl;
  Duration? _audioPosition;
  Duration? _totalDuration;
  late final VolumeWatcher _volumeWatcher;
  bool _isCaptureVolumeButtons = true;
  double _volumeSetting = 0;
  int _lastVolumeAdjustmentMillis = 0;
  bool _audio_ready = false;
  bool _srt_ready = false;

  // FlutterTts englishTts = FlutterTts();

  _MyHomePageState() {
    init();
  }

  void init() async {
    print("TEST DICT!");
    final dictStr = await rootBundle.loadString("assets/cedict_ts.txt");
    // final dictStr = await File("/sdcard/Documents/Socrates.srt").readAsString();
    _dict = Dictionary(dictStr);

    print("TEST!!!");
    print("parse: ${_dict.parse("描寫主角哈利波特在霍格華茲魔法學校7年學習生活中的冒險故事").join(" ")}");
    print(_dict.lookup("臺灣")!.getFullEntryString());

    // final srtStr = await rootBundle.loadString("assets/laogao.srt");
    // _srt = Transcript(srtStr, _dict);

    _ttsImpl = TTSImpl(_onTTSSpeechComplete);

    _initVolumeWatcher();
  }

  bool _keyHandler(KeyEvent event) {
    print(event.toString());
    return true;
  }

  void _onTTSSpeechComplete() {
    _playing = true;
    _player.resume();
  }

  Future<void> _initPlayer() async {
    https: //www.youtube.com/watch?v=jRh7Pyq1z1A&list=PLfS0WrMWEu_73gUisyRvzIFyJ6I5RFszh
    // await _player.setSource(AssetSource("laogao_audio.mp3"));
    // await _player.setSourceDeviceFile("/sdcard/Documents/Socrates.mp3");
    _player.onPositionChanged.listen(_onPlayerPositionChanged);
    _player.onDurationChanged.listen(_onPlayerDurationChanged);
    final duration = await _player.getDuration();
    setState(() {
      _totalDuration = duration;
      _audio_ready = true;
    });
  }

  void _initVolumeWatcher() async {
    _volumeSetting = await VolumeWatcher.getCurrentVolume;
    // VolumeWatcher.hideVolumeView = true;
    VolumeWatcher.addListener((newVolume) {
      if (_isCaptureVolumeButtons) {
        print("vs: $_volumeSetting nv: $newVolume");
        VolumeWatcher.setVolume(_volumeSetting);

        if (!_started) {
          return;
        }

        if (DateTime.now().millisecondsSinceEpoch -
                _lastVolumeAdjustmentMillis >
            100) {
          if (newVolume > _volumeSetting) {
            _queryMoveFoward();
          } else if (newVolume < _volumeSetting) {
            _queryMoveBack();
          } else {
            _consultDict();
          }
        }

        _lastVolumeAdjustmentMillis = DateTime.now().millisecondsSinceEpoch;
      } else {
        _volumeSetting = newVolume;
      }
    });
  }

  void _onCaptureVolumeButtonsChanged(bool captureEnabled) {
    setState(() {
      _isCaptureVolumeButtons = captureEnabled;
    });
  }

  void _onPlayerPositionChanged(Duration position) {
    setState(() {
      _audioPosition = position;
    });
  }

  void _onPlayerDurationChanged(Duration duration) {
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
    final toSay = [
      TtsItem(entry.tradHanzi, "zh-TW"),
      TtsItem(entry.definition.replaceAll("/", ";"), "en-US")
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
        (await _player.getCurrentPosition())!.inSeconds.toDouble();

    final queryingWord = _srt.getWordAtTime(positionSeconds - 1);
    _queryingAtWordIndex = queryingWord.wordIndex;

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
    _queryingAtWordIndex = _queryingAtWordIndex! - 1;
    _renderQuery(_srt.getWordAtIndex(_queryingAtWordIndex!));
  }

  void _queryMoveFoward() {
    if (_playing) {
      _consultDict();
      return;
    }

    if (_queryingAtWordIndex == null || _queryingAtWordIndex! <= 0) {
      return;
    }
    _queryingAtWordIndex = _queryingAtWordIndex! + 1;
    _renderQuery(_srt.getWordAtIndex(_queryingAtWordIndex!));
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
      _player.resume();
    } else {
      _player.pause();
    }
  }

  void _onUserSeek(Duration seekPos) {
    _player.seek(seekPos);
  }

  void _onBackButtonPress() async {
    final curPos = await _player.getCurrentPosition();

    if (curPos == null) {
      return;
    }

    _player.seek(Duration(milliseconds: (curPos.inMilliseconds) - seekTimeMs));
  }

  void _onForwardButtonPress() async {
    final curPos = await _player.getCurrentPosition();

    if (curPos == null) {
      return;
    }

    _player.seek(Duration(milliseconds: (curPos.inMilliseconds) + seekTimeMs));
  }

  void _onSelectAudioFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["mp3"]);

    if (result != null) {
      await _player.setSourceDeviceFile(result.files.single.path!);
      // await _player.setSourceBytes(result.files.single.bytes!);
      _initPlayer();
    }
  }

  void _onSelectSRTFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["srt"]);

    if (result != null) {
      File file = File(result.files.single.path!);
      _srt = Transcript(file.readAsStringSync(), _dict);
      _srt_ready = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
                Row(
                  children: [
                    Switch(
                        value: _isCaptureVolumeButtons,
                        onChanged: _onCaptureVolumeButtonsChanged),
                    const Text("Capture vol. buttons"),
                  ],
                ),
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
                          (_started && _srt_ready) ? _queryMoveBack : null,
                      child: const Icon(Icons.arrow_back)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed:
                            (_started && _srt_ready) ? _consultDict : null,
                        child: const Icon(Icons.search)),
                  ),
                  ElevatedButton(
                      onPressed:
                          (_started && _srt_ready) ? _queryMoveFoward : null,
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
                        onPressed: _audio_ready ? _playPauseButtonPress : null,
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
      ),
    );
  }
}

//43:22 被
//44:07 就
