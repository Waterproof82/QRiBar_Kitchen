import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();
  Completer<void>? _completer;

  AudioManager() {
    _player.onPlayerComplete.listen((event) {
      _completer?.complete();
      _completer = null; // Reset the completer after completion
    });
  }

  Future<void> play(String assetPath) async {
    if (_completer != null && !_completer!.isCompleted) {
      await _completer!.future;
    }

    _completer = Completer<void>();

    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print(e);
      if (!_completer!.isCompleted) {
        _completer?.completeError(e);
      }
      _completer = null; // Reset the completer on error
    }
  }
}
