import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CyberCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final bool glowEffect;
  final VoidCallback? onTap;

  const CyberCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 16,
    this.glowEffect = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              (backgroundColor ?? AppColors.cardElevated).withValues(alpha: 0.95),
              (backgroundColor ?? AppColors.card).withValues(alpha: 0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor ?? AppColors.border,
            width: 1,
          ),
          boxShadow: glowEffect
              ? [
                  BoxShadow(
                    color: AppColors.accentGreen.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: child,
      ),
    );
  }
}

/// Decorative diagonal slash element common in the Byxex design
class CyberSlash extends StatelessWidget {
  final Color color;
  final double width;
  final double height;
  final bool mirrorX;

  const CyberSlash({
    super.key,
    this.color = AppColors.accentCyan,
    this.width = 60,
    this.height = 80,
    this.mirrorX = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scaleX: mirrorX ? -1 : 1,
      child: CustomPaint(
        size: Size(width, height),
        painter: _SlashPainter(color: color),
      ),
    );
  }
}

class _SlashPainter extends CustomPainter {
  final Color color;
  _SlashPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..close();

    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final path2 = Path()
      ..moveTo(size.width * 0.3, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height)
      ..close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(_SlashPainter oldDelegate) => oldDelegate.color != color;
}
