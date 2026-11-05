class Song {
  final int id;
  final String title;
  final String artist;
  final String album;
  final String genre;
  final String thumbnailUrl;
  final String artworkUrl;
  final String? previewUrl;

  const Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.genre,
    required this.thumbnailUrl,
    required this.artworkUrl,
    this.previewUrl,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    final thumb = (json['artworkUrl100'] as String?) ?? '';
    return Song(
      id: (json['trackId'] as num?)?.toInt() ?? 0,
      title: (json['trackName'] as String?) ?? 'Tanpa judul',
      artist: (json['artistName'] as String?) ?? 'Artis tidak diketahui',
      album: (json['collectionName'] as String?) ?? '-',
      genre: (json['primaryGenreName'] as String?) ?? '-',
      thumbnailUrl: thumb,
      artworkUrl: thumb.replaceAll('100x100bb', '600x600bb'),
      previewUrl: json['previewUrl'] as String?,
    );
  }
}
