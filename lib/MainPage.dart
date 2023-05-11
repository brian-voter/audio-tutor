import 'package:audio_tutor/main.dart';
import 'package:flutter/material.dart';

import 'config_ui.dart';
import 'nav_drawer.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ting - Chinese Audio Tutor"),
      ),
      drawer: ATNavigationDrawer(_pageController),
      body: PageView(
        controller: _pageController,
        children: const [
          AudioPlayerPage(),
          ConfigEditorPage(),
        ],
      ),
    );
  }
}
