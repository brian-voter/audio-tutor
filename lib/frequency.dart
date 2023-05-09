class FrequencyList {

  final Map<String, int> _freqMap = {};

  FrequencyList(String sourceString) {
    _loadFreqMap(sourceString);
  }

  void _loadFreqMap(String sourceString) {
    final lines = sourceString.split("\n");

    for (var i = 0; i < lines.length; i++) {
      if (lines[i].isEmpty) {
        continue;
      }

      final split = lines[i].split("\t");
      _freqMap[split[0]] = i;
    }
  }

  int? lookupFrequency(String word) {
    return _freqMap[word];
  }

  int getFreqOrDefault(String word, int freqIfAbsent) {
    return _freqMap[word] ?? freqIfAbsent;
  }

}