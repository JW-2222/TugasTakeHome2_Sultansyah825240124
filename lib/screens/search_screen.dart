import 'package:flutter/material.dart';

import '../controllers/locator.dart';
import '../models/song.dart';
import '../services/itunes_service.dart';
import '../widgets/message_view.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _genres = ['Pop', 'Rock', 'Hip-Hop', 'Jazz', 'Indie', 'EDM', 'K-Pop', 'Dangdut'];

  final _controller = TextEditingController();
  List<Song> _songs = [];
  bool _loading = false;
  String? _error;
  String _query = 'Pop';
  String? _activeGenre = 'Pop';

  @override
  void initState() {
    super.initState();
    _search(_query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String term, {bool showLoader = true}) async {
    setState(() {
      _query = term;
      _error = null;
      if (showLoader) _loading = true;
    });
    try {
      final result = await itunesService.searchSongs(term);
      if (!mounted) return;
      setState(() => _songs = result);
    } on ItunesException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _submit(String text) {
    if (text.trim().isEmpty) return;
    setState(() => _activeGenre = null);
    _search(text.trim());
  }

  void _selectGenre(String genre) {
    _controller.clear();
    setState(() => _activeGenre = genre);
    _search(genre);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ListenableBuilder(
              listenable: settings,
              builder: (_, __) => Text(
                'Halo, ${settings.userName}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: _submit,
              decoration: InputDecoration(
                hintText: 'Judul lagu atau artis',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _controller.clear,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) => ChoiceChip(
                label: Text(_genres[i]),
                selected: _activeGenre == _genres[i],
                onSelected: (_) => _selectGenre(_genres[i]),
              ),
            ),
          ),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return MessageView(
        icon: Icons.wifi_off,
        message: _error!,
        actionLabel: 'Coba lagi',
        onAction: () => _search(_query),
      );
    }
    if (_songs.isEmpty) {
      return const MessageView(
        icon: Icons.search_off,
        message: 'Lagu tidak ditemukan. Coba kata kunci lain.',
      );
    }
    return RefreshIndicator(
      onRefresh: () => _search(_query, showLoader: false),
      child: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (_, i) => SongTile(
          song: _songs[i],
          onTap: () => playerController.playQueue(_songs, i),
        ),
      ),
    );
  }
}
