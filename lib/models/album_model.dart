import 'package:flutter/material.dart';
import 'track_model.dart';

class Album {
  final String id;
  final String title;
  final String artist;
  final String coverUrl;
  final String releaseYear;
  final List<Track> tracks;
  final LinearGradient gradient;

  Album({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverUrl,
    required this.releaseYear,
    required this.tracks,
    required this.gradient,
  });
}

class AlbumData {
  static List<Album> getSampleAlbums() {
    final tracks = TrackData.getSampleTracks();

    // IMPORTANT: Only use valid indices from `tracks`.
    // Your error came from `tracks[5]` when `tracks.length == 5`.

    return [
      Album(
        id: '1',
        title: 'Endless Summer',
        artist: 'The Midnight',
        coverUrl:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&q=80',
        releaseYear: '2016',
        tracks: [
          tracks[0],
          tracks[3],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Album(
        id: '2',
        title: 'Innerworld',
        artist: 'Electric Youth',
        coverUrl:
        'https://images.unsplash.com/photo-1487180144351-b8472da7d491?w=800',
        releaseYear: '2014',
        tracks: [
          tracks[1],
          tracks[4],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFf093fb),
            Color(0xFFf5576c),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Album(
        id: '3',
        title: 'Atlas',
        artist: 'FM-84',
        coverUrl:
        'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800',
        releaseYear: '2016',
        tracks: [
          tracks[2],
          tracks[4],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4facfe),
            Color(0xFF00f2fe),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Album(
        id: '4',
        title: 'Night Drive',
        artist: 'Timecop1983',
        coverUrl:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
        releaseYear: '2018',
        // FIX: removed tracks[5]; reuse existing valid track indices instead.
        tracks: [
          tracks[2],
          tracks[3],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFfa709a),
            Color(0xFFfee140),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Album(
        id: '5',
        title: 'Dark All Day',
        artist: 'Gunship',
        coverUrl:
        'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800',
        releaseYear: '2018',
        tracks: [
          tracks[0],
          tracks[2],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFff6b6b),
            Color(0xFFfeca57),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Album(
        id: '6',
        title: 'Reflections',
        artist: 'The Midnight',
        coverUrl:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800',
        releaseYear: '2019',
        tracks: [
          tracks[3],
          tracks[4],
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFF30cfd0),
            Color(0xFF330867),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];
  }
}
