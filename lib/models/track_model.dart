import 'package:flutter/material.dart';

class Track {
  final String id;
  final String title;
  final String artist;
  final String albumArt;
  final Duration duration;
  final List<Color> gradientColors;
  final Color accentColor;
  bool isLiked;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.albumArt,
    required this.duration,
    required this.gradientColors,
    required this.accentColor,
    this.isLiked = false,
  });

  // Add gradient getter that returns LinearGradient
  LinearGradient get gradient {
    return LinearGradient(
      colors: gradientColors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Track copyWith({bool? isLiked}) {
    return Track(
      id: id,
      title: title,
      artist: artist,
      albumArt: albumArt,
      duration: duration,
      gradientColors: gradientColors,
      accentColor: accentColor,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  String get durationString {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class TrackData {
  static List<Track> getSampleTracks() {
    return [
      Track(
        id: '1',
        title: 'Midnight Dreams',
        artist: 'Aurora Waves',
        albumArt:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=600',
        duration: const Duration(minutes: 3, seconds: 45),
        gradientColors: const [
          Color(0xFF667EEA),
          Color(0xFF764BA2),
          Color(0xFFFF6B9D),
        ],
        accentColor: const Color(0xFFFF6B9D),
        isLiked: true,
      ),
      Track(
        id: '2',
        title: 'Ocean Breeze',
        artist: 'Coastal Rhythms',
        albumArt:
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=600',
        duration: const Duration(minutes: 4, seconds: 12),
        gradientColors: const [
          Color(0xFF00C9FF),
          Color(0xFF0078FF),
          Color(0xFF00D9FF),
        ],
        accentColor: const Color(0xFF00D9FF),
      ),
      Track(
        id: '3',
        title: 'Sunset Vibes',
        artist: 'Golden Hour',
        albumArt:
        'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600',
        duration: const Duration(minutes: 3, seconds: 28),
        gradientColors: const [
          Color(0xFFFF512F),
          Color(0xFFFF8C00),
          Color(0xFFFFD700),
        ],
        accentColor: const Color(0xFFFF8C00),
      ),
      Track(
        id: '4',
        title: 'Neon Nights',
        artist: 'Synthwave Dreams',
        albumArt:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=600',
        duration: const Duration(minutes: 4, seconds: 56),
        gradientColors: const [
          Color(0xFFB721FF),
          Color(0xFF21D4FD),
          Color(0xFFFF2E63),
        ],
        accentColor: const Color(0xFFB721FF),
        isLiked: true,
      ),
      Track(
        id: '5',
        title: 'Electric Soul',
        artist: 'Neon Pulse',
        albumArt:
        'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=600',
        duration: const Duration(minutes: 3, seconds: 33),
        gradientColors: const [
          Color(0xFF11998E),
          Color(0xFF38EF7D),
          Color(0xFF00D9FF),
        ],
        accentColor: const Color(0xFF38EF7D),
      ),
      Track(
        id: '6',
        title: 'Starlight Drive',
        artist: 'City Lights',
        albumArt:
        'https://images.unsplash.com/photo-1514565131-fce0801e5785?w=600&q=80',
        duration: const Duration(minutes: 4, seconds: 5),
        gradientColors: const [
          Color(0xFF30cfd0),
          Color(0xFF330867),
          Color(0xFF667EEA),
        ],
        accentColor: const Color(0xFF30cfd0),
      ),
    ];
  }
}