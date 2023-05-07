import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';

class TTSImpl {
  final FlutterTts _flutterTts = FlutterTts();
  final List<TtsItem> _scheduledForSpeech = [];
  VoidCallback completionHandler;

  TTSImpl(this.completionHandler) {
    _flutterTts.setCompletionHandler(_onSpeechComplete);
  }

  interruptAndScheduleBatch(List<TtsItem> items) {
    try {
      _flutterTts.stop();
    } catch (e) {
      //}
    }
    _scheduledForSpeech.clear();
    _scheduledForSpeech.addAll(items);
    _speakNext();
  }

  stopAndClearScheduled() {
    _scheduledForSpeech.clear();
    try {
      _flutterTts.stop();
    } catch (e) {
      //}
    }
  }

  _onSpeechComplete() {
    if (_scheduledForSpeech.isNotEmpty) {
      _speakNext();
    } else {
      completionHandler();
    }
  }

  _speakNext() {
    if (_scheduledForSpeech.isNotEmpty) {
      final nextItem = _scheduledForSpeech.removeAt(0);
      _flutterTts.setLanguage(nextItem.language);
      _flutterTts.speak(nextItem.text);
    }
  }
}

class TtsItem {
  final String text;
  final String language;

  TtsItem(this.text, this.language);
}
