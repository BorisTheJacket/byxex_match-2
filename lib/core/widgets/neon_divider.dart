import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NeonDivider extends StatelessWidget {
  final Color color;
  final double height;
  final double opacity;

  const NeonDivider({
    super.key,
    this.color = AppColors.accentGreen,
    this.height = 1.5,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color.withValues(alpha: opacity),
            color.withValues(alpha: opacity),
            Colors.transparent,
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
          ),
        ],
      ),
    );
  }
}
