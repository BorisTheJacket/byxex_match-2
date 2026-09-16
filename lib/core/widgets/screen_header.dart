import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Title shown top-right on every screen. The trapezoid decoration behind it
/// is baked into the background asset, so this widget only renders the text.
class ByxexHeader extends StatelessWidget {
  final String title;

  const ByxexHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    // Anchor the title to the bg trapezoid via fractional viewport offsets so
    // it stays glued to the artwork on any device size.
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * 0.078 - 15,
        right: size.width * 0.052,
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: size.width * 0.58,
          child: FittedBox(
            alignment: Alignment.centerRight,
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                fontFamily: 'BlackHanSans',
                fontSize: 32,
                color: Colors.white,
                letterSpacing: 2.5,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shared full-screen background. Renders `menu_bg.png` with `BoxFit.cover`
/// (the trapezoid header decoration is part of the asset) and falls back
/// to the solid theme color if the asset can't be loaded.
class ByxexBackground extends StatelessWidget {
  final Widget child;
  const ByxexBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/images/screen_bg.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: AppColors.background),
        ),
        child,
      ],
    );
  }
}

/// The standard green "BACK" / primary action button
class ByxexButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isDark;

  const ByxexButton({
    super.key,
    required this.label,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [Color(0xFF0D1A8A), Color(0xFF060D7A)],
                )
              : AppColors.greenButtonGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.button,
        ),
      ),
    );
  }
}

/// A dark rounded text field matching Figma input style
class ByxexTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? hint;
  final TextInputType keyboardType;

  const ByxexTextField({
    super.key,
    required this.label,
    this.controller,
    this.hint,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.bodyLarge),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
