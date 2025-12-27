import 'package:flutter/material.dart';

import 'track_model.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final List<Track> tracks;
  final LinearGradient gradient;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.tracks,
    required this.gradient,
  });
}

class PlaylistData {
  static List<Playlist> getSamplePlaylists() {
    final tracks = TrackData.getSampleTracks();

    Track safeTrack(int index) {
      if (tracks.isEmpty) return tracks.first;
      if (index < 0) return tracks.first;
      if (index >= tracks.length) {
        // Wrap index so we never hit RangeError
        return tracks[index % tracks.length];
      }
      return tracks[index];
    }

    return [
      Playlist(
        id: '1',
        name: 'Chill Vibes',
        description: 'Relaxing tracks for evening',
        imageUrl:
        'https://images.unsplash.com/photo-1614149162883-504ce4d13909?auto=format&fit=crop&w=800&q=80',
        tracks: [
          safeTrack(0),
          safeTrack(3),
          safeTrack(4),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Playlist(
        id: '2',
        name: 'Workout Mix',
        description: 'High energy tracks to pump you up',
        imageUrl:
        'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800',
        tracks: [
          safeTrack(1),
          safeTrack(2),
          safeTrack(4),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Playlist(
        id: '3',
        name: 'Focus Flow',
        description: 'Music to help you concentrate',
        imageUrl:
        'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800',
        tracks: [
          safeTrack(0),
          safeTrack(2),
          safeTrack(3),
          safeTrack(4),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Playlist(
        id: '4',
        name: 'Night Drive',
        description: 'Perfect tunes for late night cruising',
        imageUrl:
        'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
        tracks: [
          safeTrack(1),
          safeTrack(4),
          safeTrack(5), // now safe because of safeTrack + 6th track
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Playlist(
        id: '5',
        name: 'Summer Hits',
        description: 'Best tracks of the season',
        imageUrl:
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800',
        tracks: [
          safeTrack(2),
          safeTrack(4),
          safeTrack(5),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFFff6b6b), Color(0xFFfeca57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Playlist(
        id: '6',
        name: 'Acoustic Sessions',
        description: 'Stripped down and intimate',
        imageUrl:
        'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=800',
        tracks: [
          safeTrack(0),
          safeTrack(1),
          safeTrack(3),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF30cfd0), Color(0xFF330867)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];
  }
}
