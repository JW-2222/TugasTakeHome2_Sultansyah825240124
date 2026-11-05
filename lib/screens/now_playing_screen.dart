import 'dart:math';

import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/artwork.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  double? _dragValue;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([playerController, settings]),
      builder: (context, _) {
        final song = playerController.current;
        if (song == null) return const Scaffold();
        final isFav = settings.isFavorite(song);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, size: 32),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Sedang diputar'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Artwork(url: song.artworkUrl, size: 600, radius: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            song.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    IconButton(
                      iconSize: 28,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? AppTheme.green : null,
                      ),
                      onPressed: () => settings.toggleFavorite(song),
                    ),
                  ],
                ),
                _buildSlider(),
                _buildControls(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSlider() {
    return ValueListenableBuilder<Duration>(
      valueListenable: playerController.position,
      builder: (context, pos, _) {
        final total = max(1.0, playerController.duration.value.inMilliseconds.toDouble());
        final value = (_dragValue ?? pos.inMilliseconds.toDouble()).clamp(0.0, total).toDouble();
        return Column(
          children: [
            Slider(
              value: value,
              max: total,
              onChanged: (v) => setState(() => _dragValue = v),
              onChangeEnd: (v) {
                playerController.seek(Duration(milliseconds: v.toInt()));
                setState(() => _dragValue = null);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(Duration(milliseconds: value.toInt()))),
                  Text(formatDuration(playerController.duration.value)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_previous),
          onPressed: playerController.previous,
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 34,
          backgroundColor: AppTheme.green,
          child: IconButton(
            iconSize: 40,
            color: Colors.black,
            icon: Icon(playerController.isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: playerController.togglePlay,
          ),
        ),
        const SizedBox(width: 16),
        IconButton(
          iconSize: 40,
          icon: const Icon(Icons.skip_next),
          onPressed: playerController.next,
        ),
      ],
    );
  }
}
