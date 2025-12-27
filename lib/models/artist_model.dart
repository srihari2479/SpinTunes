import 'package:flutter/material.dart';
import 'track_model.dart';

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String bio;
  final List<Track> topTracks;
  final int monthlyListeners;
  final LinearGradient gradient;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.bio,
    required this.topTracks,
    required this.monthlyListeners,
    required this.gradient,
  });
}

class ArtistData {
  static List<Artist> getSampleArtists() {
    final tracks = TrackData.getSampleTracks();

    return [
      Artist(
        id: '1',
        name: 'The Midnight',
        imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=800',
        bio: 'Synthwave duo creating nostalgic electronic soundscapes',
        topTracks: [tracks[0], tracks[3]],
        monthlyListeners: 2500000,
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Artist(
        id: '2',
        name: 'Electric Youth',
        imageUrl: 'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800',
        bio: 'Canadian synthpop artists known for dreamy melodies',
        topTracks: [tracks[1], tracks[4]],
        monthlyListeners: 1800000,
        gradient: const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Artist(
        id: '3',
        name: 'FM-84',
        imageUrl: 'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=800',
        bio: 'Scottish producer of retro-inspired synthwave',
        topTracks: [tracks[2], tracks[4]],
        monthlyListeners: 3200000,
        gradient: const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Artist(
        id: '4',
        name: 'Timecop1983',
        imageUrl: 'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800',
        bio: 'Dutch electronic music producer and composer',
        topTracks: [tracks[5]],
        monthlyListeners: 1500000,
        gradient: const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      Artist(
        id: '5',
        name: 'Gunship',
        imageUrl: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800',
        bio: 'British synthwave band with cinematic sounds',
        topTracks: [tracks[0], tracks[2]],
        monthlyListeners: 2100000,
        gradient: const LinearGradient(
          colors: [Color(0xFFff6b6b), Color(0xFFfeca57)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];
  }
}
