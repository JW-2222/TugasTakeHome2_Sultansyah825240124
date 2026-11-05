import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/song.dart';

class ItunesException implements Exception {
  final String message;
  const ItunesException(this.message);

  @override
  String toString() => message;
}

class ItunesService {
  Future<List<Song>> searchSongs(String term, {int limit = 25}) async {
    final uri = Uri.https('itunes.apple.com', '/search', {
      'term': term,
      'media': 'music',
      'entity': 'song',
      'limit': '$limit',
    });

    try {
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw ItunesException('Server bermasalah (kode ${response.statusCode}).');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>?) ?? [];

      return results
          .map((item) => Song.fromJson(item as Map<String, dynamic>))
          .where((song) => song.previewUrl != null)
          .toList();
    } on ItunesException {
      rethrow;
    } on TimeoutException {
      throw const ItunesException('Koneksi terlalu lama. Coba lagi.');
    } on FormatException {
      throw const ItunesException('Data dari server tidak valid.');
    } catch (_) {
      throw const ItunesException('Tidak dapat terhubung ke internet.');
    }
  }
}
