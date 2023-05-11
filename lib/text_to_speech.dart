import 'dart:ui';
import 'package:audio_tutor/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TTSImpl {
  // static const twVoice = "cmn-tw-x-ctc-local";
  // static const twVoice = "cmn-tw";
  // static const Map<String, String> voiceMap = {
  //   "name": twVoice,
  //   "locale": "zh-TW"
  // };
  static final FlutterTts _flutterTts = FlutterTts();
  final List<TtsItem> _scheduledForSpeech = [];
  VoidCallback completionHandler;
  static final List<Voice> chineseVoices = [];
  static final List<Voice> englishVoices = [];

  TTSImpl(this.completionHandler) {
    _initTts();
  }

  _initTts() async {
    _flutterTts.setCompletionHandler(_onSpeechComplete);
    loadVoiceLists();
  }

  static loadVoiceLists() async {
    (await getVoicesForLanguage("cmn"))?.forEach((voice) {
      if (voice != null) {
        chineseVoices.add(voice);
      }
    });

    (await getVoicesForLanguage("en"))?.forEach((voice) {
      if (voice != null) {
        englishVoices.add(voice);
      }
    });
  }

  // static getVoices() async {
  //   final voices = await _flutterTts.getVoices;
  //   return voices;
  // }

  static Future<List<Voice?>?> getVoicesForLanguage(
      String languagePrefix) async {
    final voiceMaps = castOrNull<List<Object?>>(await _flutterTts.getVoices);

    if (voiceMaps == null) {
      return null;
    }

    final List<Voice?> voices = voiceMaps
        .map((o) {
          final map = castOrNull<Map<Object?, Object?>>(o);

          final name = castOrNull<String>(map?["name"]);
          final locale = castOrNull<String>(map?["locale"]);

          if (name != null && locale != null) {
            return Voice(name, locale);
          }
        })
        .where(
            (voice) => voice != null && voice.name.startsWith(languagePrefix))
        .toList();

    return voices;
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
      if (nextItem.voice != null) {
        _flutterTts
            .setVoice({"locale": nextItem.voice!.locale, "name": nextItem.voice!.name});
      }
      _flutterTts.speak(nextItem.text);
    }
  }
}

class TtsItem {
  final String text;
  final String language;
  final Voice? voice;

  TtsItem(this.text, this.language, this.voice);
}

class Voice {
  final String name;
  final String locale;

  Voice(this.name, this.locale);
}
