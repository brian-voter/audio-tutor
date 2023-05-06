import 'dart:math';

class Dictionary {
  final _entries = <DictionaryEntry>[];
  final _simpleMap = <String, int>{};
  final _tradMap = <String, int>{};
  int _longestEntry = -1;

  Dictionary(String sourceText) {
    final lines = sourceText.split("\n");

    var index = 0;
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.startsWith("#")) {
        continue;
      }

      final separated = line.split(" ");

      final simp = separated[0];
      final trad = separated[1];

      if (simp.length > _longestEntry) {
        _longestEntry = simp.length;
      }

      final reading = line.substring(line.indexOf("[") + 1, line.indexOf("]"));
      final meaning = line.substring(line.indexOf("/") + 1);

      _simpleMap[simp] = index;
      _tradMap[trad] = index++;
      _entries.add(DictionaryEntry(simp, trad, reading, meaning));
    }
  }

  DictionaryEntry? lookup(String word) {
    if (_simpleMap.containsKey(word)) {
      return _entries[_simpleMap[word]!];
    } else if (_tradMap.containsKey(word)) {
      return _entries[_tradMap[word]!];
    }

    return null;
  }

  List<String> parse(String text) {
    var longestLen = _longestEntry;
    var index = 0;

    List<String> result = [];

    while (index < text.length) {
      var found = false;
      for (var curLen = min(longestLen, text.length - index);
          curLen >= 1;
          curLen--) {
        var substr = text.substring(index, index + curLen);

        // we found a result!
        if (lookup(substr) != null) {
          result.add(substr);
          index += substr.length;
          found = true;
          break;
        }
      }

      if (!found) {
        result.add(text[index]);
        index++;
      }
    }

    return result;
  }
}

class DictionaryEntry {
  final String simplifiedHanzi;
  final String tradHanzi;
  final String reading;
  final String definition;

  DictionaryEntry(
      this.simplifiedHanzi, this.tradHanzi, this.reading, this.definition);

  getFullEntryString() {
    return "$simplifiedHanzi $tradHanzi [$reading]: $definition";
  }
}
