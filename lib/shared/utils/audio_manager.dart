import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';

/// A final class to manage audio playback using `audioplayers` package.
///
/// This class handles playing audio from assets and ensures that
/// only one audio playback is active at a time.
final class AudioManager {
  /// The [AudioPlayer] instance used for playing audio.
  final AudioPlayer _player = AudioPlayer();

  /// A [Completer] used to track the completion of the current audio playback.
  Completer<void>? _completer;

  /// Creates an instance of [AudioManager].
  ///
  /// Sets up a listener for `onPlayerComplete` events to complete the [_completer].
  AudioManager() {
    _player.onPlayerComplete.listen((event) {
      _completer?.complete();
      _completer = null;
    });
  }

  /// Plays an audio file from the given [assetPath].
  ///
  /// If another audio is currently playing, it waits for it to complete
  /// before starting the new playback.
  /// Logs any errors during playback.
  Future<void> play(String assetPath) async {
    // If a completer exists and is not completed, wait for the previous playback to finish.
    if (_completer != null && !_completer!.isCompleted) {
      await _completer!.future;
    }

    // Create a new completer for the current playback.
    _completer = Completer<void>();

    try {
      // Start playing the audio from the asset.
      await _player.play(AssetSource(assetPath));
    } catch (e, stackTrace) {
      // Log the error if playback fails and complete the completer with an error.
      log(
        'Error playing audio from asset "$assetPath": $e',
        error: e,
        stackTrace: stackTrace,
      );
      if (!_completer!.isCompleted) {
        _completer?.completeError(e);
      }
      _completer = null;
    }
  }

  /// Disposes the [AudioManager] and releases its resources.
  ///
  Future<void> dispose() async {
    await _player.dispose();
    _completer?.complete();
    _completer = null;
  }
}

/// A final top-level instance of [AudioManager] to manage audio playback.
/// This instance is created once when the file is loaded.
final AudioManager _audioManager = AudioManager();

/// Plays a bell sound.
///
/// Attempts to play the 'sounds/bell.mp3' file using the global [AudioManager] instance.
Future<void> reproducirTimbre() async {
  try {
    await _audioManager.play('sounds/bell.mp3');
  } catch (e, stackTrace) {
    log('Error al reproducir timbre: $e', error: e, stackTrace: stackTrace);
  }
}
