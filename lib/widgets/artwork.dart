import 'package:flutter/material.dart';

class Artwork extends StatelessWidget {
  final String url;
  final double size;
  final double radius;

  const Artwork({super.key, required this.url, required this.size, this.radius = 6});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: size,
          height: size,
          color: Colors.grey.shade800,
          child: const Icon(Icons.music_note, color: Colors.white54),
        ),
      ),
    );
  }
}
