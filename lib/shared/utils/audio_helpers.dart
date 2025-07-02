import 'package:qribar_cocina/shared/utils/audio_manager.dart';

final AudioManager _audio_manager = AudioManager();

Future<void> reproducirTimbre() async {
  try {
    await _audio_manager.play('sounds/bell.mp3');
  } catch (e) {
    print('Error al reproducir timbre: $e');
  }
}
