import 'package:audio_tutor/nav_drawer.dart';
import 'package:flutter/material.dart';

class ConfigEditor extends StatefulWidget {
  const ConfigEditor({super.key, required this.title});

  static const String routeName = "/configEditor";

  final String title;

  @override
  State<ConfigEditor> createState() => _ConfigEditorState();
}

class _ConfigEditorState extends State<ConfigEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: const ATNavigationDrawer(),
        body: const Center(
          child: Text("Hi from the config!"),
        ));
  }
}
