import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  static const _images = [
    'assets/images/game_1.png',
    'assets/images/game_2.png',
    'assets/images/game_3.png',
    'assets/images/game_4.png',
    'assets/images/game_5.png',
    'assets/images/game_6.png',
    'assets/images/game_7.png',
    'assets/images/game_8.png',
  ];

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int row = 0; row < 4; row++) {
      if (row > 0) rows.add(const SizedBox(height: 12));
      final left = row * 2;
      final right = row * 2 + 1;
      rows.add(
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: _GameCard(path: _images[left], index: left),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GameCard(path: _images[right], index: right),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'GAMES'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: rows,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
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

class _GameCard extends StatefulWidget {
  final String path;
  final int index;
  const _GameCard({required this.path, required this.index});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        scale: _pressed ? 0.97 : 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.card,
              image: DecorationImage(
                image: AssetImage(widget.path),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 360.ms,
          delay: Duration(milliseconds: widget.index * 60),
        )
        .slideY(
          begin: 0.18,
          duration: 400.ms,
          delay: Duration(milliseconds: widget.index * 60),
          curve: Curves.easeOutCubic,
        );
  }
}
