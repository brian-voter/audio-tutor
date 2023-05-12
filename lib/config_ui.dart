import 'package:audio_tutor/config.dart';
import 'package:audio_tutor/main.dart';
import 'package:audio_tutor/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfigEditorPage extends StatefulWidget {
  const ConfigEditorPage({super.key});

  static const String routeName = "/configEditor";

  @override
  State<ConfigEditorPage> createState() => _ConfigEditorPageState();
}

class _ConfigEditorPageState extends State<ConfigEditorPage>
    with AutomaticKeepAliveClientMixin {
  _ConfigEditorPageState();

  Config _editingConfig = configsBox.get(mainBox.get(activeConfigKey))!;

  _setEditingConfig(String configName) {
    setState(() {
      _editingConfig = configsBox.get(configName)!;
    });
  }

  _addNewConfig() {
    var newNum = 1;
    const baseName = "New Config";

    while (configsBox.containsKey("$baseName $newNum")) {
      newNum++;
    }

    final newConfig = Config()..configName = "$baseName $newNum";
    configsBox.put(newConfig.configName, newConfig);

    setState(() {
      _editingConfig = newConfig;
    });
  }

  _promptDeleteCurrentConfig() {
    if (_editingConfig.configName == defaultConfigName) {
      return;
    }

    final alert = AlertDialog(
      title: const Text("Delete Config"),
      content:
          Text("Are you sure you wish to delete ${_editingConfig.configName}?"),
      actions: [
        TextButton(
            onPressed: () {
              final activeCfgName = mainBox.get(activeConfigKey);
              if (activeCfgName != null &&
                  activeCfgName == _editingConfig.configName) {
                mainBox.put(activeCfgName, defaultConfigName);
              }

              _editingConfig.delete();
              setState(() {
                _editingConfig = configsBox.get(defaultConfigName)!;
              });
              Navigator.pop(context);
            },
            child: const Text("Delete")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _onChangeEditingConfigName(String newName) {
    setState(() {
      _editingConfig = configsBox.get(newName)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Padding(
            padding: EdgeInsets.all(4.0),
            child: Text("Now Editing:"),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: DropdownButton<String>(
                value: _editingConfig.configName,
                items: configsBox.keys
                    .map((name) => DropdownMenuItem<String>(
                          value: name,
                          child: Text(name),
                        ))
                    .toList(),
                onChanged: (configName) => _setEditingConfig(configName!)),
          ),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateColor.resolveWith((states) =>
                      (_editingConfig.configName == defaultConfigName
                          ? Colors.black26
                          : Colors.red))),
              onPressed: () => (_editingConfig.configName == defaultConfigName
                  ? null
                  : _promptDeleteCurrentConfig()),
              child: Row(
                children: const [
                  Icon(Icons.delete_forever_outlined),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text("Delete Config"),
                  ),
                ],
              )),
          TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateColor.resolveWith(
                      (states) => Colors.black87)),
              onPressed: () => _addNewConfig(),
              child: Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: Text("New Config"),
                  ),
                  Icon(Icons.add_circle_outline_outlined),
                ],
              )),
        ]),
        const Divider(thickness: 3, color: Colors.black87),
        Expanded(
            child: ConfigEditor(_editingConfig, _onChangeEditingConfigName))
      ],
    ));
  }

  @override
  // TODO: fix this?
  bool get wantKeepAlive => true;
}

class ConfigEditor extends StatefulWidget {
  final Config _editingConfig;
  final Function(String) _changeConfigNameCallback;

  const ConfigEditor(this._editingConfig, this._changeConfigNameCallback,
      {super.key});

  @override
  State<StatefulWidget> createState() => _ConfigEditorState();
}

class _ConfigEditorState extends State<ConfigEditor> {
  final _formKey = GlobalKey<FormState>();
  late final _cfgNameController =
      TextEditingController(text: widget._editingConfig.configName);

  _updateConfigName(String newName) async {
    if (widget._editingConfig.configName == defaultConfigName ||
        newName == defaultConfigName) {
      return;
    }

    await configsBox.delete(widget._editingConfig.configName);
    await configsBox.put(newName, widget._editingConfig);

    if (widget._editingConfig.configName == mainBox.get(activeConfigKey)) {
      await mainBox.put(activeConfigKey, newName);
    }

    widget._editingConfig.configName = newName;
    widget._editingConfig.save();

    showToast("Config name updated!");

    widget._changeConfigNameCallback(newName);

    //TODO: is this a good idea?
    // AudioPlayerPageState.onConfigsUpdated();
  }

  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getVoiceSelectionDropdownButton(
      Voice selected, List<Voice> voices, void Function(Voice?)? onChanged) {
    return DropdownButton<Voice>(
      value: selected,
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
                  // initialValue: widget._editingConfig.configName,
                  controller: _cfgNameController,
                  enabled:
                      (widget._editingConfig.configName != defaultConfigName),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a configuration name';
                    }

                    if (value != widget._editingConfig.configName &&
                        configsBox.containsKey(value)) {
                      return 'That name is already in use!';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    if (_formKey.currentState?.validate() == true) {
                      final newName = _cfgNameController.value.text;
                      _updateConfigName(newName);
                      primaryFocus?.nextFocus();
                    }
                  },
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text("Chinese TTS Voice: "),
              Expanded(
                  child: _getVoiceSelectionDropdownButton(
                      TTSImpl.chineseVoices.firstWhere(
                          (voice) =>
                              voice.name ==
                              widget._editingConfig.ttsChineseVoice,
                          orElse: () => TTSImpl.chineseVoices.first),
                      TTSImpl.chineseVoices, (voice) {
                if (voice != null) {
                  setState(() {
                    widget._editingConfig.ttsChineseLocale = voice.locale;
                    widget._editingConfig.ttsChineseVoice = voice.name;
                    widget._editingConfig.save();
                  });
                  showToast("Chinese Voice Updated to: ${voice.name}");
                }
              }))
            ],
          ),
          Row(
            children: [
              const Text("English TTS Voice: "),
              Expanded(
                  child: _getVoiceSelectionDropdownButton(
                      TTSImpl.englishVoices.firstWhere(
                          (voice) =>
                              voice.name ==
                              widget._editingConfig.ttsEnglishVoice,
                          orElse: () => TTSImpl.englishVoices.first),
                      TTSImpl.englishVoices, (voice) {
                if (voice != null) {
                  setState(() {
                    widget._editingConfig.ttsEnglishLocale = voice.locale;
                    widget._editingConfig.ttsEnglishVoice = voice.name;
                    widget._editingConfig.save();
                  });
                  showToast("English Voice Updated to: ${voice.name}");
                }
              }))
            ],
          ),
          Row(
            children: [
              const Text("Ignore words below frequency: "),
              Expanded(
                child: SpinBox(
                  min: 1,
                  max: 200000,
                  value: widget._editingConfig.ignoreWordsBelowFrequency
                      .toDouble(),
                  step: 100,
                  onChanged: (value) {
                    setState(() {
                      widget._editingConfig.ignoreWordsBelowFrequency =
                          value.toInt();
                      widget._editingConfig.save();
                    });
                  },
                ),
              )
            ],
          ),
        ]),
      ),
    ));
  }
}
