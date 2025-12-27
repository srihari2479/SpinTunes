import 'dart:async';
import 'package:flutter/material.dart';
import '../models/track_model.dart';
import '../models/playlist_model.dart';
import '../models/artist_model.dart';
import '../models/album_model.dart';

class MusicProvider extends ChangeNotifier {
  List<Track> tracks = TrackData.getSampleTracks();
  final List<Playlist> playlists = PlaylistData.getSamplePlaylists();
  final List<Artist> artists = ArtistData.getSampleArtists();
  final List<Album> albums = AlbumData.getSampleAlbums();

  List<Track> recentlyPlayed = [];
  final List<Track> favorites = [];

  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isShuffle = false;
  RepeatMode _repeatMode = RepeatMode.off;
  Duration _currentPosition = Duration.zero;
  double _volume = 0.7;
  Timer? _progressTimer;

  List<Track> get allTracks => tracks;
  List<Playlist> get allPlaylists => playlists;
  List<Artist> get allArtists => artists;
  List<Album> get allAlbums => albums;
  List<Track> get recent => recentlyPlayed;
  List<Track> get favs => favorites;

  Track get currentTrack => tracks[_currentIndex];
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isShuffle => _isShuffle;
  RepeatMode get repeatMode => _repeatMode;
  Duration get currentPosition => _currentPosition;
  double get volume => _volume;

  double get progress {
    if (currentTrack.duration.inMilliseconds == 0) return 0;
    return _currentPosition.inMilliseconds /
        currentTrack.duration.inMilliseconds;
  }

  MusicProvider() {
    // Initial recently played setup
    if (tracks.length >= 5) {
      recentlyPlayed = [
        tracks[0],
        tracks[2],
        tracks[1],
        tracks[4],
      ];
    }

    for (var track in tracks) {
      if (track.isLiked) {
        favorites.add(track);
      }
    }
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    if (_isPlaying) {
      _startProgressTimer();
    } else {
      _stopProgressTimer();
    }
    notifyListeners();
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer =
        Timer.periodic(const Duration(milliseconds: 100), (timer) {
          if (_currentPosition < currentTrack.duration) {
            _currentPosition += const Duration(milliseconds: 100);
            notifyListeners();
          } else {
            _handleTrackEnd();
          }
        });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
  }

  void _handleTrackEnd() {
    switch (_repeatMode) {
      case RepeatMode.one:
        _currentPosition = Duration.zero;
        break;
      case RepeatMode.all:
        skipNext();
        break;
      case RepeatMode.off:
        if (_currentIndex < tracks.length - 1) {
          skipNext();
        } else {
          _isPlaying = false;
          _stopProgressTimer();
          notifyListeners();
        }
        break;
    }
  }

  void skipNext() {
    if (_isShuffle) {
      int newIndex;
      do {
        newIndex = DateTime.now().millisecondsSinceEpoch % tracks.length;
      } while (newIndex == _currentIndex && tracks.length > 1);
      _currentIndex = newIndex;
    } else {
      _currentIndex = (_currentIndex + 1) % tracks.length;
    }
    _currentPosition = Duration.zero;
    notifyListeners();
  }

  void skipPrevious() {
    if (_currentPosition.inSeconds > 3) {
      _currentPosition = Duration.zero;
    } else {
      _currentIndex =
          (_currentIndex - 1 + tracks.length) % tracks.length;
      _currentPosition = Duration.zero;
    }
    notifyListeners();
  }

  void seekTo(double value) {
    _currentPosition = Duration(
      milliseconds:
      (value * currentTrack.duration.inMilliseconds).round(),
    );
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case RepeatMode.off:
        _repeatMode = RepeatMode.all;
        break;
      case RepeatMode.all:
        _repeatMode = RepeatMode.one;
        break;
      case RepeatMode.one:
        _repeatMode = RepeatMode.off;
        break;
    }
    notifyListeners();
  }

  void toggleLike() {
    final updated =
    currentTrack.copyWith(isLiked: !currentTrack.isLiked);
    tracks[_currentIndex] = updated;

    if (updated.isLiked) {
      if (!favorites.contains(updated)) {
        favorites.add(updated);
      }
    } else {
      favorites.removeWhere((t) => t.id == updated.id);
    }
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void selectTrack(int index) {
    if (index < 0 || index >= tracks.length) return;
    _currentIndex = index;
    _currentPosition = Duration.zero;
    if (!_isPlaying) {
      _isPlaying = true;
      _startProgressTimer();
    }
    notifyListeners();
  }

  void playTrack(Track track) {
    final index = tracks.indexOf(track);
    if (index != -1) {
      _currentIndex = index;
      _isPlaying = true;
      _currentPosition = Duration.zero;
      _startProgressTimer();

      // Add to recently played
      recentlyPlayed.remove(track);
      recentlyPlayed.insert(0, track);
      if (recentlyPlayed.length > 10) {
        recentlyPlayed.removeLast();
      }

      notifyListeners();
    }
  }

  void playPlaylist(Playlist playlist) {
    if (playlist.tracks.isNotEmpty) {
      tracks = List.from(playlist.tracks);
      _currentIndex = 0;
      _isPlaying = true;
      _currentPosition = Duration.zero;
      _startProgressTimer();
      notifyListeners();
    }
  }

  void playAlbum(Album album) {
    if (album.tracks.isNotEmpty) {
      tracks = List.from(album.tracks);
      _currentIndex = 0;
      _isPlaying = true;
      _currentPosition = Duration.zero;
      _startProgressTimer();
      notifyListeners();
    }
  }

  void playArtistTopTracks(Artist artist) {
    if (artist.topTracks.isNotEmpty) {
      tracks = List.from(artist.topTracks);
      _currentIndex = 0;
      _isPlaying = true;
      _currentPosition = Duration.zero;
      _startProgressTimer();
      notifyListeners();
    }
  }

  List<Track> searchTracks(String query) {
    if (query.isEmpty) return [];
    return TrackData.getSampleTracks()
        .where((track) =>
    track.title.toLowerCase().contains(query.toLowerCase()) ||
        track.artist.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Playlist> searchPlaylists(String query) {
    if (query.isEmpty) return [];
    return playlists
        .where((playlist) =>
    playlist.name.toLowerCase().contains(query.toLowerCase()) ||
        playlist.description
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
  }

  List<Artist> searchArtists(String query) {
    if (query.isEmpty) return [];
    return artists
        .where((artist) =>
        artist.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Album> searchAlbums(String query) {
    if (query.isEmpty) return [];
    return albums
        .where((album) =>
    album.title.toLowerCase().contains(query.toLowerCase()) ||
        album.artist.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }
}

enum RepeatMode { off, all, one }
