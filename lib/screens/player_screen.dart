import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/music_provider.dart';
import '../widgets/floating_particles.dart';
import '../widgets/vinyl_disc.dart';
import '../widgets/waveform_visualizer.dart';
import '../widgets/glass_card.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';
import '../widgets/track_list.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<double> _gradientAnimation;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _showTrackList(BuildContext context) {
    final provider = context.read<MusicProvider>();
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TrackListSheet(
        tracks: provider.tracks,
        currentIndex: provider.currentIndex,
        onTrackSelected: (index) => provider.selectTrack(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final isSmallScreen = size.width < 380;

    return Consumer<MusicProvider>(
      builder: (context, provider, _) {
        final currentTrack = provider.currentTrack;
        final gradientColors = currentTrack.gradientColors;
        final accentColor = currentTrack.accentColor;

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Animated gradient background
              AnimatedBuilder(
                animation: _gradientAnimation,
                builder: (context, child) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(
                          -1 + _gradientAnimation.value * 0.5,
                          -1 + _gradientAnimation.value * 0.3,
                        ),
                        end: Alignment(
                          1 - _gradientAnimation.value * 0.5,
                          1 - _gradientAnimation.value * 0.3,
                        ),
                        colors: [
                          gradientColors[0].withOpacity(0.6),
                          gradientColors[1].withOpacity(0.4),
                          gradientColors[2].withOpacity(0.3),
                          Colors.black,
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
              // Floating particles
              Positioned.fill(
                child: FloatingParticles(
                  colors: gradientColors,
                  particleCount: 25,
                ),
              ),
              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: SafeArea(
                  child: Column(
                    children: [
                      // Top bar
                      _buildTopBar(context, accentColor),
                      // Vinyl disc section
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Vinyl disc
                              VinylDisc(
                                albumArt: currentTrack.albumArt,
                                isPlaying: provider.isPlaying,
                                accentColor: accentColor,
                                size: isSmallScreen ? 220 : 280,
                              ),
                              const SizedBox(height: 32),
                              // Track info
                              _buildTrackInfo(currentTrack, provider, accentColor),
                            ],
                          ),
                        ),
                      ),
                      // Controls section
                      Expanded(
                        flex: 3,
                        child: GlassCard(
                          blur: 25,
                          opacity: 0.08,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(36),
                          ),
                          padding: EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            padding.bottom + 16,
                          ),
                          margin: EdgeInsets.zero,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Progress bar
                                GlowingProgressBar(
                                  progress: provider.progress,
                                  currentPosition: provider.currentPosition,
                                  totalDuration: currentTrack.duration,
                                  accentColor: accentColor,
                                  onSeek: provider.seekTo,
                                ),
                                const SizedBox(height: 20),
                                // Player controls
                                PlayerControls(accentColor: accentColor),
                                const SizedBox(height: 16),
                                // Volume and extra controls
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    VolumeSlider(
                                      volume: provider.volume,
                                      accentColor: accentColor,
                                      onChanged: provider.setVolume,
                                    ),
                                    GestureDetector(
                                      onTap: () => _showTrackList(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(
                                          Icons.queue_music_rounded,
                                          color: Colors.white70,
                                          size: 24,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Waveform visualizer
                                SizedBox(
                                  height: 50,
                                  child: WaveformVisualizer(
                                    isPlaying: provider.isPlaying,
                                    accentColor: accentColor,
                                    barCount: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context, Color accentColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GlassIconButton(
            icon: Icons.keyboard_arrow_down_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            size: 42,
            iconColor: Colors.white70,
            glowColor: accentColor,
            showGlow: false,
          ),
          Column(
            children: [
              Text(
                'NOW PLAYING',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor,
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.6),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'SpinTunes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GlassIconButton(
            icon: Icons.more_horiz_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            size: 42,
            iconColor: Colors.white70,
            glowColor: accentColor,
            showGlow: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTrackInfo(
      dynamic currentTrack,
      MusicProvider provider,
      Color accentColor,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  currentTrack.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  currentTrack.artist,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          LikeButton(
            isLiked: currentTrack.isLiked,
            onPressed: provider.toggleLike,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }
}