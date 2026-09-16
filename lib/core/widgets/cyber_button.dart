import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum CyberButtonVariant { primary, outlined, ghost }

class CyberButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final CyberButtonVariant variant;
  final IconData? icon;
  final double height;
  final bool isLoading;

  const CyberButton({
    super.key,
    required this.label,
    this.onTap,
    this.variant = CyberButtonVariant.primary,
    this.icon,
    this.height = 52,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: 150.ms,
        height: height,
        decoration: _decoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _textColor,
                ),
              )
            else ...[
              if (icon != null) ...[
                Icon(icon, color: _textColor, size: 18),
                const SizedBox(width: 8),
              ],
              Text(label, style: AppTextStyles.button.copyWith(color: _textColor)),
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration get _decoration {
    switch (variant) {
      case CyberButtonVariant.primary:
        return BoxDecoration(
          gradient: AppColors.greenButtonGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGreen.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case CyberButtonVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.accentGreen, width: 1.5),
        );
      case CyberButtonVariant.ghost:
        return BoxDecoration(
          color: AppColors.accentGreen.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        );
    }
  }

  Color get _textColor {
    switch (variant) {
      case CyberButtonVariant.primary:
        return AppColors.background;
      case CyberButtonVariant.outlined:
      case CyberButtonVariant.ghost:
        return AppColors.accentGreen;
    }
  }
}
