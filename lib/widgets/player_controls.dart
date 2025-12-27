import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/music_provider.dart';
import 'glass_card.dart';

class PlayerControls extends StatelessWidget {
  final Color accentColor;

  const PlayerControls({
    super.key,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (context, provider, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shuffle button
            GlassIconButton(
              icon: Icons.shuffle_rounded,
              onPressed: () {
                HapticFeedback.lightImpact();
                provider.toggleShuffle();
              },
              size: 44,
              iconColor: provider.isShuffle ? accentColor : Colors.white70,
              glowColor: accentColor,
              isActive: provider.isShuffle,
            ),
            const SizedBox(width: 16),
            // Previous button
            GlassIconButton(
              icon: Icons.skip_previous_rounded,
              onPressed: () {
                HapticFeedback.mediumImpact();
                provider.skipPrevious();
              },
              size: 52,
              iconColor: Colors.white,
              glowColor: accentColor,
            ),
            const SizedBox(width: 16),
            // Play/Pause button
            PlayPauseButton(
              isPlaying: provider.isPlaying,
              accentColor: accentColor,
              onPressed: () {
                HapticFeedback.heavyImpact();
                provider.togglePlay();
              },
            ),
            const SizedBox(width: 16),
            // Next button
            GlassIconButton(
              icon: Icons.skip_next_rounded,
              onPressed: () {
                HapticFeedback.mediumImpact();
                provider.skipNext();
              },
              size: 52,
              iconColor: Colors.white,
              glowColor: accentColor,
            ),
            const SizedBox(width: 16),
            // Repeat button
            GlassIconButton(
              icon: _getRepeatIcon(provider.repeatMode),
              onPressed: () {
                HapticFeedback.lightImpact();
                provider.toggleRepeat();
              },
              size: 44,
              iconColor: provider.repeatMode != RepeatMode.off
                  ? accentColor
                  : Colors.white70,
              glowColor: accentColor,
              isActive: provider.repeatMode != RepeatMode.off,
            ),
          ],
        );
      },
    );
  }

  IconData _getRepeatIcon(RepeatMode mode) {
    switch (mode) {
      case RepeatMode.one:
        return Icons.repeat_one_rounded;
      case RepeatMode.all:
      case RepeatMode.off:
        return Icons.repeat_rounded;
    }
  }
}

class PlayPauseButton extends StatefulWidget {
  final bool isPlaying;
  final Color accentColor;
  final VoidCallback onPressed;

  const PlayPauseButton({
    super.key,
    required this.isPlaying,
    required this.accentColor,
    required this.onPressed,
  });

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    if (widget.isPlaying) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.animateTo(0);
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
    widget.onPressed();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _pulseAnimation.value,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.accentColor,
                    widget.accentColor.withOpacity(0.7),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.5),
                    blurRadius: 25,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  widget.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  key: ValueKey(widget.isPlaying),
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  final bool isLiked;
  final VoidCallback onPressed;
  final Color accentColor;

  const LikeButton({
    super.key,
    required this.isLiked,
    required this.onPressed,
    required this.accentColor,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.4)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.4, end: 0.9)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_bounceController);
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLiked && !oldWidget.isLiked) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onPressed();
      },
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.isLiked
                    ? widget.accentColor.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Icon(
                widget.isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: widget.isLiked ? const Color(0xFFFF4D6D) : Colors.white70,
                size: 28,
              ),
            ),
          );
        },
      ),
    );
  }
}
