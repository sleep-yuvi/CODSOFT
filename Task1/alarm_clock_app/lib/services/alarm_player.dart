import 'package:audioplayers/audioplayers.dart';

class AlarmPlayer {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAlarm() async {
    await _audioPlayer.play(AssetSource('alarm_sound.mp3'));
  }

  Future<void> stopAlarm() async {
    await _audioPlayer.stop();
  }
}
