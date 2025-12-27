import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingParticles extends StatefulWidget {
  final List<Color> colors;
  final int particleCount;

  const FloatingParticles({
    super.key,
    required this.colors,
    this.particleCount = 30,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  late List<Particle> _particles;
  late AnimationController _controller;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initParticles();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  void _initParticles() {
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 6 + 2,
        speedX: (_random.nextDouble() - 0.5) * 0.002,
        speedY: -_random.nextDouble() * 0.003 - 0.001,
        opacity: _random.nextDouble() * 0.6 + 0.2,
        colorIndex: _random.nextInt(widget.colors.length),
        phase: _random.nextDouble() * math.pi * 2,
      );
    });
  }

  @override
  void didUpdateWidget(FloatingParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors) {
      for (var particle in _particles) {
        particle.colorIndex = _random.nextInt(widget.colors.length);
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
          painter: ParticlePainter(
            particles: _particles,
            colors: widget.colors,
            animationValue: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speedX;
  double speedY;
  double opacity;
  int colorIndex;
  double phase;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.colorIndex,
    required this.phase,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final List<Color> colors;
  final double animationValue;

  ParticlePainter({
    required this.particles,
    required this.colors,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final time = animationValue * 20;

      double px = particle.x + math.sin(time + particle.phase) * 0.02 + particle.speedX * time;
      double py = particle.y + particle.speedY * time;

      px = px % 1.0;
      if (px < 0) px += 1.0;
      py = py % 1.0;
      if (py < 0) py += 1.0;

      final pulseOpacity = particle.opacity *
          (0.5 + 0.5 * math.sin(time * 2 + particle.phase));

      final color = colors[particle.colorIndex % colors.length]
          .withOpacity(pulseOpacity.clamp(0.1, 0.8));

      final paint = Paint()
        ..color = color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 0.5);

      canvas.drawCircle(
        Offset(px * size.width, py * size.height),
        particle.size,
        paint,
      );

      final glowPaint = Paint()
        ..color = color.withOpacity(pulseOpacity * 0.3)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.size * 2);

      canvas.drawCircle(
        Offset(px * size.width, py * size.height),
        particle.size * 1.5,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
