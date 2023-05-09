// run code generator: flutter pub run build_runner build
//  id: BigInt.parse("-3644000870443854999").toInt(),
// set config to final instead of const

import 'package:get_storage/get_storage.dart';
import 'package:uuid/uuid.dart';

class Config {

  static const uuid = Uuid();
  static final _configMap = ReadWriteValue("configMap", <String, String>{});

  late final String id;
  late final StorageFactory _box;

  Config._(this.id) {
    _box = () => GetStorage(id);
  }

  static Config newConfig(String configName) {
    final map = _configMap.val;
    if (map.containsKey(configName)) {
      throw ConfigNameTakenException();
    }

    final id = uuid.v1();
    final instance = Config._(id);
    instance.configName.val = configName;

    map[configName] = id;
    _configMap.val = map;

    return instance;
  }

  static Config loadConfig(String configName) {
    if (!_configMap.val.containsKey(configName)) {
      throw ConfigNameNotFoundException();
    }

    final id = _configMap.val[configName]!;

    return Config._(id);
  }

  static bool doesConfigExist(String configName) {
    return _configMap.val.containsKey(configName);
  }

  static Future<void> deleteConfig(String configName) async {
    if (!doesConfigExist(configName)) {
      throw ConfigNameNotFoundException();
    }

    final map = _configMap.val;

    final id = map.remove(configName)!;
    await GetStorage(id).erase();

    await GetStorage().write(_configMap.key, map);
  }

  late final configName = ReadWriteValue("configName", "Default", _box);
  late final ttsChineseLocale = ReadWriteValue("ttsChineseLocale", "zh-TW", _box);
  late final ttsChineseVoice = ReadWriteValue("ttsChineseVoice", "cmn-tw-x-ctc-network", _box);
  late final ttsEnglishLocale = ReadWriteValue("ttsEnglishLocale", "en-US", _box);
  late final ttsEnglishVoice = ReadWriteValue("ttsEnglishVoice", "", _box);
  late final ignoreWordsBelowFrequency = ReadWriteValue("ignoreWordsBelowFrequency", 0, _box);

}

class ConfigNameTakenException implements Exception {

}

class ConfigNameNotFoundException implements Exception {

}