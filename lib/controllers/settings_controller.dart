import 'package:flutter/material.dart';
import '../models/song.dart';

class SettingsController extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  String userName = 'Pengguna';
  final List<Song> _favorites = [];

  List<Song> get favorites => List.unmodifiable(_favorites);
  bool get isDark => themeMode == ThemeMode.dark;

  void setDark(bool value) {
    themeMode = value ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setUserName(String name) {
    if (name.trim().isEmpty) return;
    userName = name.trim();
    notifyListeners();
  }

  bool isFavorite(Song song) => _favorites.any((s) => s.id == song.id);

  void toggleFavorite(Song song) {
    if (isFavorite(song)) {
      _favorites.removeWhere((s) => s.id == song.id);
    } else {
      _favorites.insert(0, song);
    }
    notifyListeners();
  }
}
