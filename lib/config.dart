import 'package:isar/isar.dart';

part 'config.g.dart';

// run code generator: flutter pub run build_runner build

@collection
class Config {

  Id id = Isar.autoIncrement;

  String? configName;

  String? ttsChineseLocale;
  String? ttsChineseVoice;

  String? ttsEnglishLocale;
  String? ttsEnglishVoice;

  int? ignoreWordsBelowFrequency;

  bool? isActiveConfig;

}