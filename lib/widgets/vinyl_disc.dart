import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VinylDisc extends StatefulWidget {
  final String albumArt;
  final bool isPlaying;
  final Color accentColor;
  final double size;

  const VinylDisc({
    super.key,
    required this.albumArt,
    required this.isPlaying,
    required this.accentColor,
    this.size = 280,
  });

  @override
  State<VinylDisc> createState() => _VinylDiscState();
}

class _VinylDiscState extends State<VinylDisc>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    if (widget.isPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(VinylDisc oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * math.pi,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.accentColor.withOpacity(0.4),
              blurRadius: 40,
              spreadRadius: 5,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer vinyl disc
            Container(
              width: widget.size,
              height: widget.size,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Color(0xFF2A2A2A),
                    Color(0xFF1A1A1A),
                    Color(0xFF0D0D0D),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
              child: CustomPaint(
                painter: VinylGroovesPainter(
                  accentColor: widget.accentColor,
                ),
                size: Size(widget.size, widget.size),
              ),
            ),
            // Glossy reflection overlay
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.white.withOpacity(0.05),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
            // Center label with album art
            Container(
              width: widget.size * 0.38,
              height: widget.size * 0.38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withOpacity(0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.albumArt,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor.withOpacity(0.5),
                          widget.accentColor,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.accentColor.withOpacity(0.5),
                          widget.accentColor,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.album,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Center hole
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: const Color(0xFF3A3A3A),
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VinylGroovesPainter extends CustomPainter {
  final Color accentColor;

  VinylGroovesPainter({required this.accentColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;
    final minRadius = size.width * 0.2;

    // Draw grooves
    final groovePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (double r = minRadius; r < maxRadius; r += 3) {
      final normalizedRadius = (r - minRadius) / (maxRadius - minRadius);
      final opacity = 0.1 + normalizedRadius * 0.2;

      groovePaint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(center, r, groovePaint);
    }

    // Draw accent highlight grooves
    final highlightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = accentColor.withOpacity(0.15);

    for (double r = minRadius + 10; r < maxRadius - 10; r += 12) {
      canvas.drawCircle(center, r, highlightPaint);
    }

    // Draw edge highlight
    final edgePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(center, maxRadius - 2, edgePaint);
  }

  @override
  bool shouldRepaint(VinylGroovesPainter oldDelegate) {
    return oldDelegate.accentColor != accentColor;
  }
}
