import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../providers/music_provider.dart';
import '../widgets/glass_card.dart';
import 'package:go_router/go_router.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumId;

  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, musicProvider, child) {
        final album = musicProvider.albums.firstWhere(
              (a) => a.id == widget.albumId,
        );

        return Scaffold(
          backgroundColor: const Color(0xFF0a0e27),
          body: Stack(
            children: [
              // Animated Background
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      album.gradient.colors.first.withOpacity(0.3),
                      const Color(0xFF0a0e27),
                      const Color(0xFF0a0e27),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              SafeArea(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Back Button
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => context.pop(),
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Album Cover
                            Hero(
                              tag: 'album_${album.id}',
                              child: Container(
                                width: 240,
                                height: 240,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: album.gradient.colors.first.withOpacity(0.6),
                                      blurRadius: 50,
                                      spreadRadius: 10,
                                      offset: const Offset(0, 20),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: CachedNetworkImage(
                                    imageUrl: album.coverUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Album Info
                            Text(
                              album.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              album.artist,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Album • ${album.releaseYear}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${album.tracks.length} songs',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Play Button
                            GestureDetector(
                              onTap: () {
                                musicProvider.playAlbum(album);
                                context.push('/player');
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 48,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: album.gradient,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: album.gradient.colors.first.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.play_arrow, color: Colors.white, size: 28),
                                    SizedBox(width: 8),
                                    Text(
                                      'Play All',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 24)),

                    // Track List
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final track = album.tracks[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(milliseconds: 400 + (index * 50)),
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(50 * (1 - value), 0),
                                child: Opacity(
                                  opacity: value,
                                  child: _buildTrackItem(context, track, index),
                                ),
                              );
                            },
                          );
                        },
                        childCount: album.tracks.length,
                      ),
                    ),

                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTrackItem(BuildContext context, track, int index) {
    return GestureDetector(
      onTap: () {
        context.read<MusicProvider>().playTrack(track);
        context.push('/player');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        child: GlassCard(
          child: Row(
            children: [
              // Track Number
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // Album Art
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: track.gradient.colors.first.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: track.albumArt,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      track.artist,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Duration
              Text(
                track.durationString,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),

              const SizedBox(width: 8),

              // More Options
              IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.white.withOpacity(0.6),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
