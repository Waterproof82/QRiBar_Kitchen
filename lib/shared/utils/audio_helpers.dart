import 'dart:developer'; // For logging errors

import 'package:qribar_cocina/shared/utils/audio_manager.dart';

/// A final top-level instance of [AudioManager] to manage audio playback.
/// This instance is created once when the file is loaded.
final AudioManager _audioManager = AudioManager();

/// Plays a bell sound.
///
/// Attempts to play the 'sounds/bell.mp3' file using the global [AudioManager] instance.
Future<void> reproducirTimbre() async {
  try {
    await _audioManager.play('sounds/bell.mp3');
  } catch (e) {
    log('Error al reproducir timbre: $e');
  }
}
