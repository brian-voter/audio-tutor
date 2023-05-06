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
  int _counter = 0;

  bool playing = false;

  final player = AudioPlayer();

  _MyHomePageState() {
    player.setSource(AssetSource("laogao_audio.mp3"));
    testDict();
  }

  void testDict() async {
    print("TEST DICT!");
    final dictStr = await rootBundle.loadString("assets/cedict_ts.txt");
    final dict = Dictionary(dictStr);

    print("TEST!!!");
    print(dict.lookup("臺灣")!.getFullEntryString());
  }

  void _playPauseButtonPress() {
    playing = !playing;

    if (playing) {
      player.resume();
    } else {
      player.pause();
    }

    setState(() {
      _counter++;
    });
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
            Text(
              'You have pushed the button this many times:',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            ElevatedButton(onPressed: _playPauseButtonPress, 
                child: Icon(playing ? Icons.pause : Icons.play_arrow)),
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
