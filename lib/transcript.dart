import 'package:audio_tutor/dictionary.dart';

class Transcript {
  final String srtText;
  final List<SubtitleLine> _subLines = [];
  final List<SubtitleWord> _words = [];
  int _totalSubLines = -1;
  int _totalWords = -1;

  int get totalSubLines => _totalSubLines;

  int get totalWords => _totalWords;

  Transcript(this.srtText, Dictionary dict) {
    _buildTranscript(dict);
    _totalSubLines = _subLines.length;
    _totalWords = _words.length;
  }

  SubtitleWord getWordAtTime(double timeSeconds) {
    for (var i = 0; i < _words.length; i++) {
      final line = _words[i];

      if (line.includesTime(timeSeconds)) {
        return line;
      }

      if (i > 0 &&
          timeSeconds > _words[i - 1].endSeconds &&
          timeSeconds < line.startSeconds) {
        return _words[i - 1]; //TODO: fix this method
      }
    }

    throw Exception("Specified time is out of range");
  }

  SubtitleLine getLineAtTime(double timeSeconds) {
    for (var i = 0; i < _subLines.length; i++) {
      final line = _subLines[i];

      if (line.includesTime(timeSeconds)) {
        return line;
      }

      if (i > 0 &&
          timeSeconds > _subLines[i - 1].endSeconds &&
          timeSeconds < line.startSeconds) {
        return _words[i - 1]; //TODO: fix this method
      }
    }

    throw Exception("Specified time is out of range");
  }

  SubtitleWord getWordAtIndex(int index) {
    return _words[index];
  }

  SubtitleLine getLineAtIndex(int index) {
    return _subLines[index];
  }

  _buildTranscript(Dictionary dict) {
    final lines = srtText.split("\n");

    // const result: Array<SubtitleLine> = [];

    double startTime = -1;
    double endTime = -1;
    int lineNum = 0;
    for (final line in lines) {
      lineNum++;

      if (line.trim().isEmpty || int.tryParse(line.trim()) != null) {
        continue;
      }

      if (line.contains("-->")) {
        final times = line.split("-->");
        startTime = timeStringToSeconds(times[0].trim());
        endTime = timeStringToSeconds(times[1].trim());
        continue;
      }

      // should be a text line

      if (startTime == -1 || endTime == -1) {
        throw Exception("Failed to parse SRT at line $lineNum!");
      }

      final trimmed = line.trim();

      final parsedWords = dict.parse(trimmed);

      final interpolated = Transcript.interpolateTimesForWords(
          parsedWords, startTime, endTime, _subLines.length, _words.length);

      _words.addAll(interpolated);
      _subLines
          .add(SubtitleLine(startTime, endTime, trimmed, _subLines.length));
    }

    // print("lines: ", subLines.slice(0, 3));
    // console.log("words: ", this.words.slice(0, 50));
  }

  static List<SubtitleWord> interpolateTimesForWords(
      List<String> words,
      double startSeconds,
      double endSeconds,
      int subtitleLineIndex,
      int lastWordIndex) {
    final List<SubtitleWord> result = [];
    final lengthPer = (endSeconds - startSeconds) / words.length;

    for (var i = 0; i < words.length; i++) {
      final start = startSeconds + (i * lengthPer) + 0.01;
      final end = startSeconds + ((i + 1) * lengthPer) - 0.01;

      final newWord = SubtitleWord(
          start, end, words[i], subtitleLineIndex, (lastWordIndex + i + 1));

      result.add(newWord);
    }
    return result;
  }
}

class SubtitleWord extends SubtitleLine {
  final int wordIndex;

  SubtitleWord(super.startSeconds, super.endSeconds, super.text,
      super.lineIndex, this.wordIndex);
}

class SubtitleLine {
  final double startSeconds;
  final double endSeconds;
  final String text;
  final int lineIndex;
  late double _midTime;

  double get midTime => _midTime;

  SubtitleLine(this.startSeconds, this.endSeconds, this.text, this.lineIndex) {
    _midTime = startSeconds / endSeconds;
  }

  bool includesTime(double timeSeconds) {
    return timeSeconds <= endSeconds && timeSeconds >= startSeconds;
  }
}

double timeStringToSeconds(String timeString) {
  final split = timeString.split(",");
  final left = split[0];
  final right = split[1];

  final millis = double.parse(right);

  final hoursMinSec = left.split(":").map((s) => double.parse(s)).toList();


  return hoursMinSec[2] +
      (hoursMinSec[1] * 60) +
      (hoursMinSec[0] * 3600) +
      (millis / 1000);
}
