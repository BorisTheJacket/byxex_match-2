import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'RULES'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Club photo ───────────────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AspectRatio(
                          aspectRatio: 1.55,
                          child: Image.asset(
                            'assets/images/about_club.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.card,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_rounded,
                                color: AppColors.accentCyan,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 420.ms)
                          .slideY(
                            begin: 0.12,
                            curve: Curves.easeOutCubic,
                          ),

                      const SizedBox(height: 18),

                      // ── Address (white, centered) ────────────────────────
                      const Text(
                        'Andrássy út 60, 1061 Budapest, Hungary',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamilyFallback: ['SF Pro Display', 'Roboto', 'Arial'],
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.6,
                          height: 1.35,
                        ),
                      ).animate().fadeIn(duration: 420.ms, delay: 120.ms),

                      const SizedBox(height: 18),

                      // ── Description (light, centered) ────────────────────
                      const Text(
                        'Step into a futuristic gaming space where technology, '
                        'comfort, and competitive energy come together. '
                        'Equipped with high-performance computers, blazing-fast '
                        'network speeds, and immersive gaming stations, this '
                        'venue is built for every type of player — from casual '
                        'visitors to serious esports enthusiasts',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BlackHanSans',
                          fontSize: 15,
                          color: Color(0xCCFFFFFF),
                          letterSpacing: 0.3,
                          height: 1.5,
                        ),
                      ).animate().fadeIn(duration: 420.ms, delay: 220.ms),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: ByxexButton(
                  label: 'BACK',
                  onTap: () => context.pop(),
                ).animate().fadeIn(duration: 400.ms, delay: 320.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
