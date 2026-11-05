import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../screens/now_playing_screen.dart';
import 'artwork.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: playerController,
      builder: (context, _) {
        final song = playerController.current;
        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => const NowPlayingScreen(),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  dense: true,
                  leading: Artwork(url: song.thumbnailUrl, size: 40, radius: 4),
                  title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: Icon(playerController.isPlaying ? Icons.pause : Icons.play_arrow),
                    onPressed: playerController.togglePlay,
                  ),
                ),
                ValueListenableBuilder<Duration>(
                  valueListenable: playerController.position,
                  builder: (_, pos, __) {
                    final total = playerController.duration.value.inMilliseconds;
                    return LinearProgressIndicator(
                      minHeight: 2,
                      value: total == 0 ? 0 : (pos.inMilliseconds / total).clamp(0.0, 1.0),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
