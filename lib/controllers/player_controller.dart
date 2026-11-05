import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/song.dart';

class PlayerController extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<Song> _queue = [];
  int _index = -1;

  bool isPlaying = false;
  String? errorMessage;
  final ValueNotifier<Duration> position = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> duration = ValueNotifier(const Duration(seconds: 30));

  PlayerController() {
    _player.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      notifyListeners();
    });
    _player.onPositionChanged.listen((p) => position.value = p);
    _player.onDurationChanged.listen((d) => duration.value = d);
    _player.onPlayerComplete.listen((_) => next());
  }

  Song? get current => (_index >= 0 && _index < _queue.length) ? _queue[_index] : null;

  Future<void> playQueue(List<Song> queue, int index) async {
    _queue = List.of(queue);
    _index = index;
    notifyListeners();
    await _playCurrent();
  }

  Future<void> _playCurrent() async {
    final url = current?.previewUrl;
    if (url == null) return;
    try {
      errorMessage = null;
      position.value = Duration.zero;
      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (_) {
      errorMessage = 'Gagal memutar lagu.';
      notifyListeners();
    }
  }

  Future<void> togglePlay() async {
    if (current == null) return;
    if (isPlaying) {
      await _player.pause();
    } else if (_player.state == PlayerState.paused) {
      await _player.resume();
    } else {
      await _playCurrent();
    }
  }

  Future<void> next() async {
    if (_index < _queue.length - 1) {
      _index++;
      notifyListeners();
      await _playCurrent();
    } else {
      await _player.stop();
      position.value = Duration.zero;
    }
  }

  Future<void> previous() async {
    if (position.value.inSeconds > 3 || _index <= 0) {
      await seek(Duration.zero);
    } else {
      _index--;
      notifyListeners();
      await _playCurrent();
    }
  }

  Future<void> seek(Duration to) => _player.seek(to);

  @override
  void dispose() {
    _player.dispose();
    position.dispose();
    duration.dispose();
    super.dispose();
  }
}
