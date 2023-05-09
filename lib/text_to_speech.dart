import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSImpl {
  // static const twVoice = "cmn-tw-x-ctc-local";
  static const twVoice = "cmn-tw";
  static const Map<String, String> voiceMap = {
    "name": twVoice,
    "locale": "zh-TW"
  };
  FlutterTts _flutterTts = FlutterTts();
  final List<TtsItem> _scheduledForSpeech = [];
  VoidCallback completionHandler;

  TTSImpl(this.completionHandler) {
    _initTts();
    getVoices();
  }

  _initTts() {
    _flutterTts.setCompletionHandler(_onSpeechComplete);
  }


  getVoices() async {
    final voices = await _flutterTts.getVoices;
    print("voices: $voices");
  }

  interruptAndScheduleBatch(List<TtsItem> items) async {
    await _stopAudio();
    _scheduledForSpeech.clear();
    _scheduledForSpeech.addAll(items);
    _speakNext();
  }

  _stopAudio() async {
    await _flutterTts.stop();

    // note: seems to break on web after being stopped once.
    // if (kIsWeb) {
    //   _flutterTts = FlutterTts();
    //   _initTts();
    //   //TODO: is this necessary?
    // }
  }

  stopAndClearScheduled() async {
    _scheduledForSpeech.clear();
    await _stopAudio();
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
