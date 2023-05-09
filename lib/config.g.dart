// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetConfigCollection on Isar {
  IsarCollection<Config> get configs => this.collection();
}

const ConfigSchema = CollectionSchema(
  name: r'Config',
  id: -3644000870443854999,
  properties: {
    r'configName': PropertySchema(
      id: 0,
      name: r'configName',
      type: IsarType.string,
    ),
    r'ignoreWordsBelowFrequency': PropertySchema(
      id: 1,
      name: r'ignoreWordsBelowFrequency',
      type: IsarType.long,
    ),
    r'isActiveConfig': PropertySchema(
      id: 2,
      name: r'isActiveConfig',
      type: IsarType.bool,
    ),
    r'ttsChineseLocale': PropertySchema(
      id: 3,
      name: r'ttsChineseLocale',
      type: IsarType.string,
    ),
    r'ttsChineseVoice': PropertySchema(
      id: 4,
      name: r'ttsChineseVoice',
      type: IsarType.string,
    ),
    r'ttsEnglishLocale': PropertySchema(
      id: 5,
      name: r'ttsEnglishLocale',
      type: IsarType.string,
    ),
    r'ttsEnglishVoice': PropertySchema(
      id: 6,
      name: r'ttsEnglishVoice',
      type: IsarType.string,
    )
  },
  estimateSize: _configEstimateSize,
  serialize: _configSerialize,
  deserialize: _configDeserialize,
  deserializeProp: _configDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _configGetId,
  getLinks: _configGetLinks,
  attach: _configAttach,
  version: '3.1.0+1',
);

int _configEstimateSize(
  Config object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.configName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ttsChineseLocale;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ttsChineseVoice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ttsEnglishLocale;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ttsEnglishVoice;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _configSerialize(
  Config object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.configName);
  writer.writeLong(offsets[1], object.ignoreWordsBelowFrequency);
  writer.writeBool(offsets[2], object.isActiveConfig);
  writer.writeString(offsets[3], object.ttsChineseLocale);
  writer.writeString(offsets[4], object.ttsChineseVoice);
  writer.writeString(offsets[5], object.ttsEnglishLocale);
  writer.writeString(offsets[6], object.ttsEnglishVoice);
}

Config _configDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Config();
  object.configName = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.ignoreWordsBelowFrequency = reader.readLongOrNull(offsets[1]);
  object.isActiveConfig = reader.readBoolOrNull(offsets[2]);
  object.ttsChineseLocale = reader.readStringOrNull(offsets[3]);
  object.ttsChineseVoice = reader.readStringOrNull(offsets[4]);
  object.ttsEnglishLocale = reader.readStringOrNull(offsets[5]);
  object.ttsEnglishVoice = reader.readStringOrNull(offsets[6]);
  return object;
}

P _configDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLongOrNull(offset)) as P;
    case 2:
      return (reader.readBoolOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _configGetId(Config object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _configGetLinks(Config object) {
  return [];
}

void _configAttach(IsarCollection<dynamic> col, Id id, Config object) {
  object.id = id;
}

extension ConfigQueryWhereSort on QueryBuilder<Config, Config, QWhere> {
  QueryBuilder<Config, Config, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ConfigQueryWhere on QueryBuilder<Config, Config, QWhereClause> {
  QueryBuilder<Config, Config, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Config, Config, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Config, Config, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Config, Config, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ConfigQueryFilter on QueryBuilder<Config, Config, QFilterCondition> {
  QueryBuilder<Config, Config, QAfterFilterCondition> configNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'configName',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'configName',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configName',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> configNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configName',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ignoreWordsBelowFrequency',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ignoreWordsBelowFrequency',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ignoreWordsBelowFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ignoreWordsBelowFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ignoreWordsBelowFrequency',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ignoreWordsBelowFrequencyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ignoreWordsBelowFrequency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> isActiveConfigIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isActiveConfig',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      isActiveConfigIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isActiveConfig',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> isActiveConfigEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActiveConfig',
        value: value,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ttsChineseLocale',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseLocaleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ttsChineseLocale',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseLocaleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ttsChineseLocale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseLocaleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ttsChineseLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseLocaleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ttsChineseLocale',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseLocaleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsChineseLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseLocaleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ttsChineseLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ttsChineseVoice',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseVoiceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ttsChineseVoice',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseVoiceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ttsChineseVoice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ttsChineseVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ttsChineseVoice',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsChineseVoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsChineseVoice',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsChineseVoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ttsChineseVoice',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ttsEnglishLocale',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishLocaleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ttsEnglishLocale',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishLocaleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ttsEnglishLocale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishLocaleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ttsEnglishLocale',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishLocaleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ttsEnglishLocale',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishLocaleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsEnglishLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishLocaleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ttsEnglishLocale',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ttsEnglishVoice',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishVoiceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ttsEnglishVoice',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishVoiceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ttsEnglishVoice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ttsEnglishVoice',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ttsEnglishVoice',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition> ttsEnglishVoiceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ttsEnglishVoice',
        value: '',
      ));
    });
  }

  QueryBuilder<Config, Config, QAfterFilterCondition>
      ttsEnglishVoiceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ttsEnglishVoice',
        value: '',
      ));
    });
  }
}

extension ConfigQueryObject on QueryBuilder<Config, Config, QFilterCondition> {}

extension ConfigQueryLinks on QueryBuilder<Config, Config, QFilterCondition> {}

extension ConfigQuerySortBy on QueryBuilder<Config, Config, QSortBy> {
  QueryBuilder<Config, Config, QAfterSortBy> sortByConfigName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByConfigNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByIgnoreWordsBelowFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ignoreWordsBelowFrequency', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy>
      sortByIgnoreWordsBelowFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ignoreWordsBelowFrequency', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByIsActiveConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActiveConfig', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByIsActiveConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActiveConfig', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsChineseLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseLocale', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsChineseLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseLocale', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsChineseVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseVoice', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsChineseVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseVoice', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsEnglishLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishLocale', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsEnglishLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishLocale', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsEnglishVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishVoice', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> sortByTtsEnglishVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishVoice', Sort.desc);
    });
  }
}

extension ConfigQuerySortThenBy on QueryBuilder<Config, Config, QSortThenBy> {
  QueryBuilder<Config, Config, QAfterSortBy> thenByConfigName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByConfigNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByIgnoreWordsBelowFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ignoreWordsBelowFrequency', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy>
      thenByIgnoreWordsBelowFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ignoreWordsBelowFrequency', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByIsActiveConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActiveConfig', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByIsActiveConfigDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActiveConfig', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsChineseLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseLocale', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsChineseLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseLocale', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsChineseVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseVoice', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsChineseVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsChineseVoice', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsEnglishLocale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishLocale', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsEnglishLocaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishLocale', Sort.desc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsEnglishVoice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishVoice', Sort.asc);
    });
  }

  QueryBuilder<Config, Config, QAfterSortBy> thenByTtsEnglishVoiceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ttsEnglishVoice', Sort.desc);
    });
  }
}

extension ConfigQueryWhereDistinct on QueryBuilder<Config, Config, QDistinct> {
  QueryBuilder<Config, Config, QDistinct> distinctByConfigName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Config, Config, QDistinct>
      distinctByIgnoreWordsBelowFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ignoreWordsBelowFrequency');
    });
  }

  QueryBuilder<Config, Config, QDistinct> distinctByIsActiveConfig() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActiveConfig');
    });
  }

  QueryBuilder<Config, Config, QDistinct> distinctByTtsChineseLocale(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsChineseLocale',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Config, Config, QDistinct> distinctByTtsChineseVoice(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsChineseVoice',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Config, Config, QDistinct> distinctByTtsEnglishLocale(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsEnglishLocale',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Config, Config, QDistinct> distinctByTtsEnglishVoice(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ttsEnglishVoice',
          caseSensitive: caseSensitive);
    });
  }
}

extension ConfigQueryProperty on QueryBuilder<Config, Config, QQueryProperty> {
  QueryBuilder<Config, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Config, String?, QQueryOperations> configNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configName');
    });
  }

  QueryBuilder<Config, int?, QQueryOperations>
      ignoreWordsBelowFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ignoreWordsBelowFrequency');
    });
  }

  QueryBuilder<Config, bool?, QQueryOperations> isActiveConfigProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActiveConfig');
    });
  }

  QueryBuilder<Config, String?, QQueryOperations> ttsChineseLocaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsChineseLocale');
    });
  }

  QueryBuilder<Config, String?, QQueryOperations> ttsChineseVoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsChineseVoice');
    });
  }

  QueryBuilder<Config, String?, QQueryOperations> ttsEnglishLocaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsEnglishLocale');
    });
  }

  QueryBuilder<Config, String?, QQueryOperations> ttsEnglishVoiceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ttsEnglishVoice');
    });
  }
}
