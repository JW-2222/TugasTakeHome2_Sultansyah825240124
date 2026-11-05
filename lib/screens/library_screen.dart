import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../widgets/message_view.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) {
          final favorites = settings.favorites;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Lagu favorit',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: favorites.isEmpty
                    ? const MessageView(
                        icon: Icons.favorite_border,
                        message: 'Belum ada favorit. Ketuk ikon hati pada lagu untuk menyimpannya di sini.',
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (_, i) => SongTile(
                          song: favorites[i],
                          onTap: () => playerController.playQueue(favorites, i),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
