import 'dart:async';

import 'package:audioplayers/audioplayers.dart' as audio_players;
import 'package:just_audio/just_audio.dart' as just_audio;

abstract class ATAudioPlayer {

  Future<void> play();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<Duration?> getPosition();
  Future<Duration?> getDuration();
  Stream<Duration?> getDurationStream();
  Stream<Duration?> getPositionStream();

}

class JAAudioPlayerImpl extends ATAudioPlayer {

  final just_audio.AudioPlayer _player = just_audio.AudioPlayer();

  static Future<JAAudioPlayerImpl> build(just_audio.AudioSource source) async {
    final instance = JAAudioPlayerImpl();
    await instance._player.setAudioSource(source);

    return instance;
  }

  @override
  Future<Duration?> getDuration() {
    return Future(() => _player.duration);
  }

  @override
  Stream<Duration?> getDurationStream() {
    return _player.durationStream;
  }

  @override
  Future<Duration?> getPosition() {
    return Future(() => _player.position);
  }

  @override
  Stream<Duration> getPositionStream() {
    return _player.positionStream;
  }

  @override
  Future<void> pause() {
    return _player.pause();
  }

  @override
  Future<void> play() {
    return _player.play();
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }
}

class APAudioPlayerImpl extends ATAudioPlayer {

  final audio_players.AudioPlayer _player = audio_players.AudioPlayer();

  static Future<APAudioPlayerImpl> build(String sourcePath) async {
    final instance = APAudioPlayerImpl();
    await instance._player.setSourceDeviceFile(sourcePath);

    return instance;
  }

  @override
  Future<Duration?> getDuration() {
    return _player.getDuration();
  }

  @override
  Stream<Duration> getDurationStream() {
    return _player.onDurationChanged;
  }

  @override
  Future<Duration?> getPosition() {
    return _player.getCurrentPosition();
  }

  @override
  Stream<Duration> getPositionStream() {
    return _player.onPositionChanged;
  }

  @override
  Future<void> pause() async {
    return _player.pause();
  }

  @override
  Future<void> play() {
    return _player.resume();
  }

  @override
  Future<void> seek(Duration position) {
    return _player.seek(position);
  }
}