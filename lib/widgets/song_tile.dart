import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../models/song.dart';
import '../theme/app_theme.dart';
import 'artwork.dart';

class SongTile extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;

  const SongTile({super.key, required this.song, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([playerController, settings]),
      builder: (context, _) {
        final isCurrent = playerController.current?.id == song.id;
        final isFav = settings.isFavorite(song);
        return ListTile(
          leading: Artwork(url: song.thumbnailUrl, size: 52),
          title: Text(
            song.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isCurrent ? AppTheme.green : null,
            ),
          ),
          subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? AppTheme.green : null,
            ),
            onPressed: () => settings.toggleFavorite(song),
          ),
          onTap: onTap,
        );
      },
    );
  }
}
