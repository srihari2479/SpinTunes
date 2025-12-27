import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GlowingProgressBar extends StatefulWidget {
  final double progress;
  final Duration currentPosition;
  final Duration totalDuration;
  final Color accentColor;
  final ValueChanged<double> onSeek;

  const GlowingProgressBar({
    super.key,
    required this.progress,
    required this.currentPosition,
    required this.totalDuration,
    required this.accentColor,
    required this.onSeek,
  });

  @override
  State<GlowingProgressBar> createState() => _GlowingProgressBarState();
}

class _GlowingProgressBarState extends State<GlowingProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  bool _isDragging = false;
  double _dragProgress = 0;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final displayProgress = _isDragging ? _dragProgress : widget.progress;

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onHorizontalDragStart: (details) {
                setState(() {
                  _isDragging = true;
                  _dragProgress = (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
                });
                HapticFeedback.selectionClick();
              },
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragProgress = (details.localPosition.dx / constraints.maxWidth)
                      .clamp(0.0, 1.0);
                });
              },
              onHorizontalDragEnd: (details) {
                widget.onSeek(_dragProgress);
                setState(() {
                  _isDragging = false;
                });
                HapticFeedback.lightImpact();
              },
              onTapDown: (details) {
                final newProgress = (details.localPosition.dx / constraints.maxWidth)
                    .clamp(0.0, 1.0);
                widget.onSeek(newProgress);
                HapticFeedback.lightImpact();
              },
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (context, child) {
                  return Container(
                    height: 40,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      clipBehavior: Clip.none,
                      children: [
                        // Background track
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        // Progress fill with glow
                        AnimatedContainer(
                          duration: _isDragging
                              ? Duration.zero
                              : const Duration(milliseconds: 100),
                          width: constraints.maxWidth * displayProgress,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            gradient: LinearGradient(
                              colors: [
                                widget.accentColor.withOpacity(0.7),
                                widget.accentColor,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.accentColor
                                    .withOpacity(_glowAnimation.value),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Thumb indicator
                        AnimatedPositioned(
                          duration: _isDragging
                              ? Duration.zero
                              : const Duration(milliseconds: 100),
                          left: (constraints.maxWidth * displayProgress) - 8,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: _isDragging ? 20 : 16,
                            height: _isDragging ? 20 : 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.accentColor
                                      .withOpacity(_glowAnimation.value),
                                  blurRadius: 15,
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(widget.currentPosition),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _formatDuration(widget.totalDuration),
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class VolumeSlider extends StatefulWidget {
  final double volume;
  final Color accentColor;
  final ValueChanged<double> onChanged;

  const VolumeSlider({
    super.key,
    required this.volume,
    required this.accentColor,
    required this.onChanged,
  });

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  bool _isExpanded = false;

  IconData _getVolumeIcon() {
    if (widget.volume == 0) return Icons.volume_off_rounded;
    if (widget.volume < 0.3) return Icons.volume_mute_rounded;
    if (widget.volume < 0.7) return Icons.volume_down_rounded;
    return Icons.volume_up_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
            HapticFeedback.selectionClick();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              _getVolumeIcon(),
              color: Colors.white70,
              size: 24,
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _isExpanded ? 100 : 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isExpanded ? 1.0 : 0.0,
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: widget.accentColor,
                inactiveTrackColor: Colors.white.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: widget.accentColor.withOpacity(0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6,
                ),
              ),
              child: Slider(
                value: widget.volume,
                onChanged: (value) {
                  widget.onChanged(value);
                  HapticFeedback.selectionClick();
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
