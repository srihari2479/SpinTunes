import 'dart:ui';
import 'package:flutter/material.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final double borderWidth;

  const GlassCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.opacity = 0.1,
    this.borderRadius,
    this.padding,
    this.margin,
    this.borderColor,
    this.borderWidth = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(opacity),
              borderRadius: borderRadius ?? BorderRadius.circular(24),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.2),
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class GlassIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? iconColor;
  final Color? glowColor;
  final bool isActive;
  final bool showGlow;

  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.iconColor,
    this.glowColor,
    this.isActive = false,
    this.showGlow = true,
  });

  @override
  State<GlassIconButton> createState() => _GlassIconButtonState();
}

class _GlassIconButtonState extends State<GlassIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
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
    final effectiveColor = widget.iconColor ?? Colors.white;
    final effectiveGlowColor = widget.glowColor ?? effectiveColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value * (_isHovered ? 1.1 : 1.0),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isActive
                  ? effectiveColor.withOpacity(0.2)
                  : Colors.white.withOpacity(_isHovered ? 0.15 : 0.1),
              border: Border.all(
                color: widget.isActive
                    ? effectiveColor.withOpacity(0.5)
                    : Colors.white.withOpacity(_isHovered ? 0.3 : 0.2),
                width: 1.5,
              ),
              boxShadow: widget.showGlow && (widget.isActive || _isHovered)
                  ? [
                BoxShadow(
                  color: effectiveGlowColor.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
                  : null,
            ),
            child: Icon(
              widget.icon,
              color: effectiveColor.withOpacity(widget.isActive ? 1.0 : 0.8),
              size: widget.size * 0.45,
            ),
          ),
        ),
      ),
    );
  }
}
