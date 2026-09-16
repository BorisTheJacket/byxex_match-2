import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/theme/app_text_styles.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';
import 'package:byxex_match/core/widgets/user_qr_sheet.dart';

const _avatarAssets = [
  'assets/images/avatar_1.png',
  'assets/images/avatar_2.png',
  'assets/images/avatar_3.png',
  'assets/images/avatar_4.png',
  'assets/images/avatar_5.png',
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _nickname = 'GREK';
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nickname = (prefs.getString('nickname') ?? 'GREK').toUpperCase();
      _avatarIndex = (prefs.getInt('avatar') ?? 0).clamp(0, 4);
    });
  }

  void _showDialog(String title, String body) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.background,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                body,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.overlay,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ByxexButton(
                  label: 'CLOSE',
                  onTap: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'PROFILE'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // ── Avatar + QR row ─────────────────────────────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Avatar + nickname
                          Column(
                            children: [
                              _AvatarTile(asset: _avatarAssets[_avatarIndex]),
                              const SizedBox(height: 10),
                              Text(
                                _nickname,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'BlackHanSans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  height: 1,
                                ),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 380.ms)
                              .slideX(
                                begin: -0.15,
                                curve: Curves.easeOutCubic,
                              ),
                          // QR code (decorative asset) — tap to show user QR
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => showUserQrSheet(context),
                            child: Image.asset(
                              'assets/images/home_qr.png',
                              width: 170,
                              fit: BoxFit.contain,
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 380.ms, delay: 80.ms)
                              .slideX(
                                begin: 0.15,
                                curve: Curves.easeOutCubic,
                              ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ── DISCOUNT / POINTS / RULES (plain on bg) ─────────
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'DISCOUNT: 3%',
                            style: TextStyle(
                              fontFamily: 'BlackHanSans',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'POINTS: ${SessionState.userPoints}',
                            style: const TextStyle(
                              fontFamily: 'BlackHanSans',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.2,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => context.push('/about'),
                            child: const Text(
                              'RULES',
                              style: TextStyle(
                                fontFamily: 'BlackHanSans',
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1.2,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, delay: 160.ms)
                          .slideY(
                            begin: 0.12,
                            curve: Curves.easeOutCubic,
                          ),

                      const SizedBox(height: 48),

                      // ── 3 dark-green rectangular buttons ────────────────
                      _PillButton(
                        label: 'ABOUT THE APP',
                        dark: true,
                        onTap: () => _showDialog(
                          'ABOUT THE APP',
                          'Byxex Match Cyber Club — your ultimate gaming destination. Version 1.0.0',
                        ),
                        delay: 240.ms,
                      ),
                      const SizedBox(height: 12),
                      _PillButton(
                        label: 'PRIVACY POLICY',
                        dark: true,
                        onTap: () => _showDialog(
                          'PRIVACY POLICY',
                          'We respect your privacy. Your data is securely stored and never shared with third parties.',
                        ),
                        delay: 300.ms,
                      ),
                      const SizedBox(height: 12),
                      _PillButton(
                        label: 'TERMS OF USE',
                        dark: true,
                        onTap: () => _showDialog(
                          'TERMS OF USE',
                          'By using this app you agree to our terms and conditions. For full terms visit our website.',
                        ),
                        delay: 360.ms,
                      ),
                      const SizedBox(height: 16),

                      _PillButton(
                        label: 'BACK',
                        onTap: () => context.pop(),
                        delay: 420.ms,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar tile (rounded square, green border) ─────────────────────────────
class _AvatarTile extends StatelessWidget {
  final String asset;
  const _AvatarTile({required this.asset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGreen, width: 2),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.asset(
        asset,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(
          Icons.person_rounded,
          color: AppColors.accentGreen,
          size: 60,
        ),
      ),
    );
  }
}

// ── Pill / rectangular button ──────────────────────────────────────────────
class _PillButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final Duration delay;
  final bool dark;

  const _PillButton({
    required this.label,
    required this.onTap,
    required this.delay,
    this.dark = false,
  });

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton> {
  bool _pressed = false;

  static const _darkGreen = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF066E2D), Color(0xFF034A1E)],
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : 1.0,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: widget.dark ? _darkGreen : AppColors.greenButtonGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: const TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 18,
              color: Colors.white,
              letterSpacing: 1.5,
              height: 1,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 380.ms, delay: widget.delay)
        .slideY(begin: 0.18, duration: 380.ms, curve: Curves.easeOutCubic);
  }
}
