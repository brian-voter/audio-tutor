import 'package:audio_tutor/transcript.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:audio_tutor/dictionary.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ting: Chinese Audio Tutor',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Ting: Chinese Audio Tutor'),
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
  final _player = AudioPlayer();
  bool _started = false;
  bool _playing = false;
  int _queryingAtWordIndex = 0;
  Dictionary? dict;
  Transcript? srt;
  String currentlyDisplayedDefText = "";

  _MyHomePageState() {
    _player.setSource(AssetSource("laogao_audio.mp3"));
    init();
  }

  void init() async {
    print("TEST DICT!");
    final dictStr = await rootBundle.loadString("assets/cedict_ts.txt");
    dict = Dictionary(dictStr);

    print("TEST!!!");
    print("parse: ${dict!.parse(
        "描寫主角哈利波特在霍格華茲魔法學校7年學習生活中的冒險故事").join(
        " ")}");
    print(dict!.lookup("臺灣")!.getFullEntryString());

    final srtStr = await rootBundle.loadString("assets/laogao.srt");
    srt = Transcript(srtStr, dict!);
  }

  void _pause() {
    setState(() {
      _playing = false;
    });
    _player.pause();
  }

  Future<void> _consultDict() async {
    if (!_started) {
      return;
    }

    _pause();

    final positionSeconds = (await _player.getCurrentPosition())!
        .inSeconds;
    final queryingWord = srt!.getWordAtTime(positionSeconds.toDouble());
    _queryingAtWordIndex = queryingWord.wordIndex;

    setState(() {
      currentlyDisplayedDefText =
          dict!.lookup(queryingWord.text)?.getFullEntryString() ??
              "${queryingWord.text}: No def found.";
    });
  }

  void _queryMoveBack() {
    _pause();
  }

  void _queryMoveFoward() {
    _pause();
  }

  void _playPauseButtonPress() {
    _started = true;

    setState(() {
      _playing = !_playing;
    });

    if (_playing) {
      _player.resume();
    } else {
      _player.pause();
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(currentlyDisplayedDefText, textAlign: TextAlign.center),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _queryMoveBack,
                    child: const Icon(Icons.arrow_back)),
                ElevatedButton(
                    onPressed: _consultDict, child: const Icon(Icons.search)),
                ElevatedButton(onPressed: _queryMoveFoward,
                    child: const Icon(Icons.arrow_forward)),
              ],
            ),
            ElevatedButton(onPressed: _playPauseButtonPress,
                child: Icon(_playing ? Icons.pause : Icons.play_arrow)),
            //     child: Text(
            //   playing ? "Pause" : "Play"
            // )),
            ProgressBar(
              progress: Duration(milliseconds: 1000),
              buffered: Duration(milliseconds: 2000),
              total: Duration(milliseconds: 5000),
              onSeek: (duration) {
                print('User selected a new time: $duration');
              },
            ),
          ],
        ),
      ),
    );
  }
}
