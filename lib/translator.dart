import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class Translator {
  static final _modelManager = OnDeviceTranslatorModelManager();
  static const _sourceLanguage = TranslateLanguage.chinese;
  static const _targetLanguage = TranslateLanguage.english;
  static late final _onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage: _sourceLanguage, targetLanguage: _targetLanguage);

  static Future<void> init() async {
    _downloadSourceModel();
    _downloadTargetModel();
  }

  static Future<void> _downloadSourceModel() async {
    print("Starting source translation model download...");
    _modelManager
        .downloadModel(_sourceLanguage.bcpCode)
        .then((value) => value ? 'success' : 'failed');
    print("Source translation model downloaded successful! (or existing model found)");
  }

  static Future<void> _downloadTargetModel() async {
    print("Starting target translation model download...");
    final downloaded =
        await _modelManager.downloadModel(_targetLanguage.bcpCode);

    print("Target translation model downloaded successful! (or existing model found)");
  }

  static Future<String> translateText(String text) async {
    return await _onDeviceTranslator.translateText(text);
  }
}
