import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveformVisualizer extends StatefulWidget {
  final bool isPlaying;
  final Color accentColor;
  final int barCount;

  const WaveformVisualizer({
    super.key,
    required this.isPlaying,
    required this.accentColor,
    this.barCount = 50,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _baseHeights;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _generateBaseHeights();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  void _generateBaseHeights() {
    _baseHeights = List.generate(widget.barCount, (index) {
      final centerDistance = (index - widget.barCount / 2).abs() / (widget.barCount / 2);
      return 0.3 + (1 - centerDistance) * 0.5 + _random.nextDouble() * 0.2;
    });
  }

  @override
  void didUpdateWidget(WaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
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
        return CustomPaint(
          painter: WaveformPainter(
            animationValue: _controller.value,
            isPlaying: widget.isPlaying,
            accentColor: widget.accentColor,
            baseHeights: _baseHeights,
            barCount: widget.barCount,
          ),
          size: const Size(double.infinity, 60),
        );
      },
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final bool isPlaying;
  final Color accentColor;
  final List<double> baseHeights;
  final int barCount;

  WaveformPainter({
    required this.animationValue,
    required this.isPlaying,
    required this.accentColor,
    required this.baseHeights,
    required this.barCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (barCount * 1.8);
    final spacing = barWidth * 0.8;
    final maxHeight = size.height * 0.9;

    for (int i = 0; i < barCount; i++) {
      final baseHeight = baseHeights[i];

      double heightMultiplier;
      if (isPlaying) {
        final phase = (animationValue * 2 * math.pi) + (i * 0.3);
        heightMultiplier = baseHeight * (0.4 + 0.6 * ((math.sin(phase) + 1) / 2));
      } else {
        heightMultiplier = baseHeight * 0.2;
      }

      final barHeight = maxHeight * heightMultiplier;
      final x = (i * (barWidth + spacing)) + spacing;
      final y = (size.height - barHeight) / 2;

      final gradient = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          accentColor.withOpacity(0.3),
          accentColor,
          accentColor.withOpacity(0.8),
        ],
        stops: const [0.0, 0.5, 1.0],
      );

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        Radius.circular(barWidth / 2),
      );

      final paint = Paint()
        ..shader = gradient.createShader(
          Rect.fromLTWH(x, y, barWidth, barHeight),
        );

      canvas.drawRRect(rect, paint);

      // Glow effect
      final glowPaint = Paint()
        ..color = accentColor.withOpacity(0.3 * heightMultiplier)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawRRect(rect, glowPaint);
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.isPlaying != isPlaying ||
        oldDelegate.accentColor != accentColor;
  }
}
