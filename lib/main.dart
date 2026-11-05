import 'package:flutter/material.dart';
import 'controllers/locator.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MusicApp());

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (_, __) => MaterialApp(
        title: 'Music Player',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: settings.themeMode,
        home: const HomeScreen(),
      ),
    );
  }
}
