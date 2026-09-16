import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarded') ?? false;
    if (!mounted) return;
    context.go(onboarded ? '/home' : '/onboarding');
  }

  @override
  void dispose() {
    _spinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B18B5),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image (has the cyan diagonal stripes)
          Image.asset(
            'assets/images/splash_bg.png',
            fit: BoxFit.cover,
          ),

          // Foreground content
          SafeArea(
            child: Column(
              children: [
                const Spacer(flex: 2),

                // M-shield icon
                Image.asset(
                  'assets/images/splash_icon.png',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .scaleXY(begin: 0.7, end: 1.0, duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 32),

                // BYXEX MATCH CYBER CLUB text logo
                Image.asset(
                  'assets/images/splash_text.png',
                  width: 280,
                  fit: BoxFit.contain,
                )
                    .animate()
                    .fadeIn(duration: 500.ms, delay: 500.ms)
                    .slideY(begin: 0.15, end: 0.0, duration: 500.ms, delay: 500.ms),

                const Spacer(flex: 2),

                // Spinning arc loader
                AnimatedBuilder(
                  animation: _spinController,
                  builder: (context, _) {
                    return Transform.rotate(
                      angle: _spinController.value * 2 * math.pi,
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: CircularProgressIndicator(
                          value: 0.7,
                          strokeWidth: 3,
                          color: Colors.white,
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ).animate().fadeIn(duration: 400.ms, delay: 700.ms),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
