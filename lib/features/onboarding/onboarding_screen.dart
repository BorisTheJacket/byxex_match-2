import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/theme/app_text_styles.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class _Slide {
  final String image;
  final String title;
  final String subtitle;
  final double imageWidthFactor;
  final Alignment imageAlignment;
  const _Slide({
    required this.image,
    required this.title,
    required this.subtitle,
    this.imageWidthFactor = 1.6,
    this.imageAlignment = const Alignment(-0.5, -0.2),
  });
}

const _slides = [
  _Slide(
    image: 'assets/images/onboarding_pc.png',
    title: 'GOOD PERFOMANCE',
    subtitle: 'We spend time in comfort:\nour place is perfect for this suit.',
    imageWidthFactor: 1.5,
    imageAlignment: Alignment(-0.5, -0.55),
  ),
  _Slide(
    image: 'assets/images/onboarding_trophy.png',
    title: 'POINTS AND BENEFIT',
    subtitle: 'Visit us and earn points, feel at home',
    imageWidthFactor: 1.7,
    imageAlignment: Alignment(0, -0.5),
  ),
  _Slide(
    image: 'assets/images/onboarding_events.png',
    title: 'LOTS OF EVENTS',
    subtitle: 'Watch events, improve your skills, and most importantly, have fun',
    imageWidthFactor: 1,
    imageAlignment: Alignment(0, -0.5),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  Future<void> _next() async {
    if (_currentPage < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarded', true);
      if (mounted) context.go('/nickname');
    }
  }

  Future<void> _skip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (mounted) context.go('/nickname');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B18B5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background (has BYXEX MATCH logo + diagonal stripes)
          Image.asset(
            'assets/images/onboarding_bg.png',
            fit: BoxFit.cover,
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Top bar: only SKIP (logo is baked into background)
                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 40, bottom: 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _skip,
                      child: Text(
                        'SKIP',
                        style: AppTextStyles.button.copyWith(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // PageView — illustration fills the upper area
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (context, index) {
                      return _SlidePage(slide: _slides[index]);
                    },
                  ),
                ),

                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == i
                            ? AppColors.accentGreen
                            : Colors.white.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // NEXT button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ByxexButton(
                    label: 'NEXT',
                    onTap: _next,
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Illustration — fills full slide, overflows sides
        Positioned.fill(
          child: OverflowBox(
            minWidth: 0,
            maxWidth: double.infinity,
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: slide.imageAlignment,
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width * slide.imageWidthFactor,
              child: Image.asset(
                slide.image,
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.image_rounded,
                  color: AppColors.accentCyan,
                  size: 120,
                ),
              )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scaleXY(begin: 0.88, end: 1.0, duration: 500.ms),
            ),
          ),
        ),

        // Text overlaid at bottom of image
        Positioned(
          left: 0,
          right: 0,
          bottom: 70,
          child: Column(
            children: [
              Text(
                slide.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 26,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 150.ms)
                  .slideY(begin: 0.2, end: 0.0, duration: 400.ms, delay: 150.ms),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  slide.subtitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 15,
                    color: AppColors.accentGreen,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
