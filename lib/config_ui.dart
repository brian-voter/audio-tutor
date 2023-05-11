import 'package:audio_tutor/config.dart';
import 'package:audio_tutor/main.dart';
import 'package:audio_tutor/nav_drawer.dart';
import 'package:audio_tutor/text_to_speech.dart';
import 'package:flutter/material.dart';

class ConfigEditorPage extends StatefulWidget {
  const ConfigEditorPage({super.key, required this.title});

  static const String routeName = "/configEditor";

  final String title;

  @override
  State<ConfigEditorPage> createState() => _ConfigEditorPageState();
}

class _ConfigEditorPageState extends State<ConfigEditorPage> {
  _ConfigEditorPageState();

  Config _editingConfig =
      configsBox.get(mainBox.get("activeConfig", defaultValue: "default"))!;

  setEditingConfig(String configName) {
    setState(() {
      _editingConfig = configsBox.get(configName)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: const ATNavigationDrawer(),
        body: Center(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text("Editing Config: "),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: DropdownButton<String>(
                      value: "default", //TODO: REPLACE WITH ACTIVE CONFIG
                      items: configsBox.keys
                          .map((name) => DropdownMenuItem<String>(
                                value: name,
                                child: Text(name),
                              ))
                          .toList(),
                      onChanged: (configName) =>
                          {setEditingConfig(configName!)}),
                ),
              ],
            ),
            const Divider(),
            Expanded(child: ConfigEditor(_editingConfig))
          ],
        )));
  }
}

class ConfigEditor extends StatelessWidget {
  final Config editingConfig;
  final _formKey = GlobalKey<FormState>();

  ConfigEditor(this.editingConfig, {super.key});

  _getVoiceSelectionDropdownButton(
      List<Voice> voices, void Function(Voice?)? onChanged) {
    return DropdownButton<Voice>(
      value: voices.first, //TODO: REPLACE WITH ACTIVE CONFIG
      items: voices
          .map((voice) => DropdownMenuItem<Voice>(
                value: voice,
                child: Text(voice.name),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(children: [
          Row(
            children: [
              const Text("Config Name: "),
              Expanded(
                child: TextFormField(
                  initialValue: editingConfig.configName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a configuration name';
                    }

                    if (value != editingConfig.configName &&
                        configsBox.containsKey(value)) {
                      return 'That name is already in use!';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    //TODO: SET VAL
                    _formKey.currentState?.validate();
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text("Chinese TTS Locale: "),
              Expanded(
                  child: _getVoiceSelectionDropdownButton(TTSImpl.chineseVoices,
                      (voice) {
                if (voice != null) {
                  editingConfig.ttsChineseLocale = voice.locale;
                  editingConfig.ttsChineseVoice = voice.name;
                }
              }))
            ],
          ),
          Row(
            children: [
              const Text("English TTS Locale: "),
              Expanded(
                  child: _getVoiceSelectionDropdownButton(TTSImpl.englishVoices,
                      (voice) {
                if (voice != null) {
                  editingConfig.ttsEnglishLocale = voice.locale;
                  editingConfig.ttsEnglishVoice = voice.name;
                }
              }))
            ],
          ),
        ]),
      ),
    ));
  }
}
