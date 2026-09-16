import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

const _tasks = [
  'Visit the club 5 days in a row',
  'Visit the club 10 times in a month',
  'Visit the club every day for a month',
  'Buy 3 night unlimited passes in a week',
  'Visit 3 times on weekdays (before 6:00 PM)',
  'Visit the club every day for a month',
  'Buy 3 night unlimited passes in a week',
  'Visit the club for the first time',
  'Attend a tournament for the first time',
  'Visit the club 5 times',
  'Visit the club 10 times',
  'Visit the club 100 times in total over a year',
];

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'CHALLENGES'),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _tasks.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _TaskRow(text: _tasks[i], index: i),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: ByxexButton(
                  label: 'BACK',
                  onTap: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskRow extends StatelessWidget {
  final String text;
  final int index;
  const _TaskRow({required this.text, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Pill-shape background asset (~50% transparent)
          Opacity(
            opacity: 0.50,
            child: Image.asset(
              'assets/images/challenge_card_bg.png',
              fit: BoxFit.fill,
              errorBuilder: (_, __, ___) => Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          // Centered text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'BlackHanSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 0.5,
                  height: 1.15,
                ),
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 340.ms,
          delay: Duration(milliseconds: index * 45),
        )
        .slideY(
          begin: 0.15,
          duration: 380.ms,
          delay: Duration(milliseconds: index * 45),
          curve: Curves.easeOutCubic,
        );
  }
}
