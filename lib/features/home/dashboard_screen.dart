import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/user_qr_sheet.dart';

const _avatarAssets = [
  'assets/images/avatar_1.png',
  'assets/images/avatar_2.png',
  'assets/images/avatar_3.png',
  'assets/images/avatar_4.png',
  'assets/images/avatar_5.png',
];

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _nickname = 'PLAYER';
  int _avatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _nickname = (prefs.getString('nickname') ?? 'PLAYER').toUpperCase();
      _avatarIndex = (prefs.getInt('avatar') ?? 0).clamp(0, 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/home_bg.png', fit: BoxFit.cover),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.04,
                0,
                size.width * 0.04,
                size.height * 0.025,
              ),
              physics: const BouncingScrollPhysics(),
              child: Transform.translate(
                offset: const Offset(0, -15),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header (HOME / PROFILE) anchored to bg top decoration ─
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                      bottom: size.height * 0.015,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.01),
                          child: const Text(
                            'HOME',
                            style: TextStyle(
                              fontFamily: 'BlackHanSans',
                              fontSize: 36,
                              color: Colors.white,
                              letterSpacing: 2,
                              height: 1,
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 350.ms)
                            .slideX(begin: -0.15, curve: Curves.easeOutCubic),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => context.push('/profile'),
                          child: Padding(
                            padding: EdgeInsets.only(top: size.height * 0.022),
                            child: const Text(
                              'PROFILE',
                              style: TextStyle(
                                fontFamily: 'BlackHanSans',
                                fontSize: 18,
                                color: Colors.white,
                                letterSpacing: 1.5,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                                height: 1,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 350.ms, delay: 80.ms)
                            .slideX(begin: 0.15, curve: Curves.easeOutCubic),
                      ],
                    ),
                  ),

                  // ── 2x2 grid: FOOD / PRICE / GAMES / EVENTS ───────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _Tile(
                          image: 'assets/images/home_food.png',
                          onTap: () => context.push('/menu'),
                          delay: 120.ms,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Tile(
                          image: 'assets/images/home_price.png',
                          onTap: () => context.push('/prices'),
                          delay: 170.ms,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _Tile(
                          image: 'assets/images/home_games.png',
                          onTap: () => context.push('/games'),
                          delay: 220.ms,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _Tile(
                          image: 'assets/images/home_events.png',
                          onTap: () => context.push('/events'),
                          delay: 270.ms,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Wide banners ──────────────────────────────────────────
                  _Tile(
                    image: 'assets/images/home_quests.png',
                    onTap: () => context.push('/tasks'),
                    delay: 320.ms,
                  ),
                  const SizedBox(height: 10),
                  _Tile(
                    image: 'assets/images/home_pc_settings.png',
                    onTap: () => context.push(
                        SessionState.qrVerified ? '/pc-control' : '/qr'),
                    delay: 370.ms,
                  ),
                  const SizedBox(height: 10),
                  _Tile(
                    image: 'assets/images/home_booking.png',
                    onTap: () => context.push('/booking'),
                    delay: 420.ms,
                  ),

                  SizedBox(height: size.height * 0.055),

                  // ── Bottom row: DISCOUNT / QR  +  Avatar / Nickname / Pts ─
                  _BottomSection(
                    nickname: _nickname,
                    avatarAsset: _avatarAssets[_avatarIndex],
                    points: SessionState.userPoints,
                    onDiscountTap: () => context.push('/promotions'),
                    onQrTap: () => showUserQrSheet(context),
                    onProfileTap: () => context.push('/profile'),
                  ),
                ],
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tile ───────────────────────────────────────────────────────────────────
class _Tile extends StatefulWidget {
  final String image;
  final VoidCallback onTap;
  final Duration delay;

  const _Tile({required this.image, required this.onTap, required this.delay});

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  bool _pressed = false;

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
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.asset(
            widget.image,
            width: double.infinity,
            fit: BoxFit.fitWidth,
            errorBuilder: (_, __, ___) => Container(
              height: 100,
              color: AppColors.card,
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 380.ms, delay: widget.delay)
        .slideY(begin: 0.18, duration: 420.ms, curve: Curves.easeOutCubic);
  }
}

// ── Bottom section ─────────────────────────────────────────────────────────
class _BottomSection extends StatelessWidget {
  final String nickname;
  final String avatarAsset;
  final int points;
  final VoidCallback onDiscountTap;
  final VoidCallback onQrTap;
  final VoidCallback onProfileTap;

  const _BottomSection({
    required this.nickname,
    required this.avatarAsset,
    required this.points,
    required this.onDiscountTap,
    required this.onQrTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 0),
      child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT: DISCOUNT (→ /promotions) + QR image (→ /qr)
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onDiscountTap,
                child: Transform.translate(
                  offset: const Offset(-20, 0),
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontFamily: 'BlackHanSans',
                      fontSize: 24,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                      height: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 0),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onQrTap,
                child: Image.asset(
                  'assets/images/home_qr.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 420.ms, delay: 480.ms)
            .slideY(begin: 0.2, curve: Curves.easeOutCubic),

        const SizedBox(width: 8),

        // RIGHT: avatar + nickname + points — фіксована ширина під аватар
        SizedBox(
          width: 130,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onProfileTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  width: 130,
                  height: 130,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      avatarAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: const Color(0xFF0A0C1A),
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.accentGreen,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  nickname,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'BlackHanSans',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$points',
                  style: const TextStyle(
                    fontFamily: 'BlackHanSans',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 420.ms, delay: 540.ms)
            .slideY(begin: 0.2, curve: Curves.easeOutCubic),
      ],
      ),
    );
  }
}
