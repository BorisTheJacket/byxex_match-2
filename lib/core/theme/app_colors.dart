import 'package:flutter/material.dart';

/// Color palette extracted directly from the Byxex Match Figma design.
class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────────────────────────────────
  /// Main screen background – rich royal blue with horizontal stripe texture
  static const Color background = Color(0xFF0B18B5);
  /// Slightly darker for surfaces / cards
  static const Color surface = Color(0xFF0E1FCC);
  /// Card / row fill
  static const Color card = Color(0xFF1A2CD4);
  /// Elevated card (hover/selected)
  static const Color cardElevated = Color(0xFF2035D8);

  // ── Accents ───────────────────────────────────────────────────────────────
  /// Neon green – primary CTA, selected states, prices
  static const Color accentGreen = Color(0xFF00D455);
  static const Color accentGreenDark = Color(0xFF00A842);
  /// Cyan – header slashes, secondary accents
  static const Color accentCyan = Color(0xFF00D4FF);
  /// Deep purple/blue overlay for dark areas
  static const Color overlay = Color(0xFF060D7A);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFCDD5FF);
  static const Color textHint = Color(0xFF6B7DC9);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF2845E0);
  static const Color borderGreen = Color(0xFF00D455);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF00D455);
  static const Color error = Color(0xFFFF3355);
  static const Color warning = Color(0xFFFFB800);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0B18B5), Color(0xFF060D7A)],
  );

  static const LinearGradient greenButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF00D455), Color(0xFF00A842)],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A2CD4), Color(0xFF0B18B5)],
  );

  static const LinearGradient tileGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2CD4), Color(0xFF060D7A)],
  );
}
