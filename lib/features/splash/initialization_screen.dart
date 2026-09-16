import 'package:flutter/material.dart';

import 'package:byxex_match/core/theme/app_colors.dart';

class InitializationScreen extends StatelessWidget {
  final Animation<double> rotation;
  final double progress;

  const InitializationScreen({
    super.key,
    required this.rotation,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: rotation,
              child: const Icon(
                Icons.apps,
                size: 86,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Initializing...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 280,
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: AppColors.overlay,
                color: AppColors.accentGreen,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${(progress * 100).clamp(0, 100).toInt()}%',
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}