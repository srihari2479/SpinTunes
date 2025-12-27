import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/track_model.dart';

class TrackListSheet extends StatelessWidget {
  final List<Track> tracks;
  final int currentIndex;
  final Function(int) onTrackSelected;

  const TrackListSheet({
    super.key,
    required this.tracks,
    required this.currentIndex,
    required this.onTrackSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Up Next',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${tracks.length} tracks',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              // Track list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    final isCurrentTrack = index == currentIndex;

                    return TrackListItem(
                      track: track,
                      isPlaying: isCurrentTrack,
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        onTrackSelected(index);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrackListItem extends StatefulWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onTap;

  const TrackListItem({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  State<TrackListItem> createState() => _TrackListItemState();
}

class _TrackListItemState extends State<TrackListItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.isPlaying
                ? widget.track.accentColor.withOpacity(0.2)
                : _isHovered
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isPlaying
                  ? widget.track.accentColor.withOpacity(0.4)
                  : Colors.white.withOpacity(_isHovered ? 0.15 : 0.08),
              width: 1,
            ),
            boxShadow: widget.isPlaying
                ? [
              BoxShadow(
                color: widget.track.accentColor.withOpacity(0.2),
                blurRadius: 15,
                spreadRadius: 0,
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              // Album art
              Hero(
                tag: 'album_art_${widget.track.id}',
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.track.accentColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.track.albumArt,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: widget.track.accentColor.withOpacity(0.5),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white54,
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: widget.track.accentColor.withOpacity(0.5),
                        child: const Icon(
                          Icons.album,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Track info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.track.title,
                      style: TextStyle(
                        color: widget.isPlaying
                            ? widget.track.accentColor
                            : Colors.white.withOpacity(0.9),
                        fontSize: 15,
                        fontWeight:
                        widget.isPlaying ? FontWeight.bold : FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.track.artist,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Duration and indicator
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.isPlaying)
                    _PlayingIndicator(color: widget.track.accentColor)
                  else
                    Text(
                      _formatDuration(widget.track.duration),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  if (widget.track.isLiked)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.favorite,
                        color: Color(0xFFFF4D6D),
                        size: 16,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _PlayingIndicator extends StatefulWidget {
  final Color color;

  const _PlayingIndicator({required this.color});

  @override
  State<_PlayingIndicator> createState() => _PlayingIndicatorState();
}

class _PlayingIndicatorState extends State<_PlayingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final value = ((_controller.value + delay) % 1.0);
            final height = 8.0 + (value * 8.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              width: 3,
              height: height,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(1.5),
              ),
            );
          }),
        );
      },
    );
  }
}
