import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';

class TTSImpl {
  static const twVoice = "cmn-tw-x-ctc-local";
  static const Map<String, String> voiceMap = {
    "name": twVoice,
    "locale": "zh-TW"
  };
  final FlutterTts _flutterTts = FlutterTts();
  final List<TtsItem> _scheduledForSpeech = [];
  VoidCallback completionHandler;

  TTSImpl(this.completionHandler) {
    _flutterTts.setCompletionHandler(_onSpeechComplete);
    getVoices();
  }

  getVoices() async {
    final voices = await _flutterTts.getVoices;
    print("voices: $voices");
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
      // if (nextItem.language == chineseLangTtsTag){
      //
      //   _flutterTts.setVoice(voiceMap);
      // }
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
