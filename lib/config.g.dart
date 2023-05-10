// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 0;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config()
      ..configName = fields[0] == null ? 'default' : fields[0] as String
      ..ttsChineseLocale = fields[1] == null ? 'zh-TW' : fields[1] as String
      ..ttsChineseVoice =
          fields[2] == null ? 'cmn-tw-x-ctc-network' : fields[2] as String
      ..ttsEnglishLocale = fields[3] == null ? 'en-US' : fields[3] as String
      ..ttsEnglishVoice = fields[4] == null ? '' : fields[4] as String
      ..ignoreWordsBelowFrequency = fields[5] == null ? 0 : fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.configName)
      ..writeByte(1)
      ..write(obj.ttsChineseLocale)
      ..writeByte(2)
      ..write(obj.ttsChineseVoice)
      ..writeByte(3)
      ..write(obj.ttsEnglishLocale)
      ..writeByte(4)
      ..write(obj.ttsEnglishVoice)
      ..writeByte(5)
      ..write(obj.ignoreWordsBelowFrequency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
