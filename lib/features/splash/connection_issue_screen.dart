import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:byxex_match/core/theme/app_colors.dart';

class ConnectionIssueScreen extends StatelessWidget {
  const ConnectionIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 20),
              const Text(
                'Connection Error',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              const SizedBox(height: 12),
              const Text(
                'Please check your connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: SystemNavigator.pop,
                child: const Text('Exit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}