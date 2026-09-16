import 'package:flutter/material.dart';
import 'app_colors.dart';

const _font = 'BlackHanSans';

class AppTextStyles {
  AppTextStyles._();

  // ── Titles / Headers ─────────────────────────────────────────────────────
  static const TextStyle screenTitle = TextStyle(
    fontFamily: _font,
    fontSize: 26,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 2.0,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 1.0,
  );

  static const TextStyle tileName = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        color: Color(0xB3000000),
        blurRadius: 4,
        offset: Offset(1, 1),
      ),
    ],
  );

  // ── Body ─────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // ── Prices ───────────────────────────────────────────────────────────────
  static const TextStyle priceLabel = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle priceRowName = TextStyle(
    fontFamily: _font,
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle priceRowValue = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Buttons ──────────────────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 1.5,
  );

  static const TextStyle buttonDark = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.overlay,
    letterSpacing: 1.5,
  );

  // ── Card labels ──────────────────────────────────────────────────────────
  static const TextStyle cardLabel = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    letterSpacing: 0.3,
  );

  static const TextStyle cardValue = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // ── Menu / tabs ──────────────────────────────────────────────────────────
  static const TextStyle menuTabActive = TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle hello = TextStyle(
    fontFamily: _font,
    fontSize: 32,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 3.0,
  );

  static const TextStyle yourName = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}
