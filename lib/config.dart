// run code generator: flutter pub run build_runner build
//  id: BigInt.parse("-3644000870443854999").toInt(),
// set config to final instead of const

import 'package:hive/hive.dart';

part 'config.g.dart';
//run: flutter packages pub run build_runner build

const String defaultConfigName = "Default Config";
const String activeConfigKey = "activeConfig";

@HiveType(typeId: 0)
class Config extends HiveObject {

  @HiveField(0, defaultValue: "default")
  String configName = "default";

  @HiveField(1, defaultValue: "zh-TW")
  String ttsChineseLocale = "zh-TW";

  @HiveField(2, defaultValue: "cmn-tw-x-ctc-network")
  String ttsChineseVoice = "cmn-tw-x-ctc-network";

  @HiveField(3, defaultValue: "en-US")
  String ttsEnglishLocale = "en-US";

  //TODO: default
  @HiveField(4, defaultValue: "en-US-language")
  String ttsEnglishVoice = "en-US-language";

  @HiveField(5, defaultValue: 0)
  int ignoreWordsBelowFrequency = 0;

  @HiveField(6, defaultValue: "-1, 0")
  String translateLinesRelativeSelector = "-1, 0";

  // late final ttsChineseLocale = ReadWriteValue("ttsChineseLocale", "zh-TW", _box);
  // late final ttsChineseVoice = ReadWriteValue("ttsChineseVoice", "cmn-tw-x-ctc-network", _box);
  // late final ttsEnglishLocale = ReadWriteValue("ttsEnglishLocale", "en-US", _box);
  // late final ttsEnglishVoice = ReadWriteValue("ttsEnglishVoice", "", _box);
  // late final ignoreWordsBelowFrequency = ReadWriteValue("ignoreWordsBelowFrequency", 0, _box);

}

class ConfigNameTakenException implements Exception {

}

class ConfigNameNotFoundException implements Exception {

}