import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/theme/app_text_styles.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

class PCControlScreen extends StatefulWidget {
  const PCControlScreen({super.key});

  @override
  State<PCControlScreen> createState() => _PCControlScreenState();
}

class _PCControlScreenState extends State<PCControlScreen> {
  static const int _addStepSeconds = 30 * 60; // each +/- press is 30 min

  late int _secondsRemaining;
  late bool _paused;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Catch up time elapsed while user was on other screens, then pull state.
    SessionState.syncPcTime();
    _secondsRemaining = SessionState.pcRemainingSeconds;
    _paused = SessionState.pcPaused;
    if (!_paused && _secondsRemaining > 0) {
      SessionState.pcLastTickAt = DateTime.now();
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_paused && _secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
        SessionState.pcRemainingSeconds = _secondsRemaining;
        SessionState.pcLastTickAt = DateTime.now();
      }
    });
  }

  String _format(int sec) {
    final m = sec ~/ 60;
    final s = sec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _addTime() {
    setState(() => _secondsRemaining += _addStepSeconds);
    SessionState.pcRemainingSeconds = _secondsRemaining;
    if (!_paused) SessionState.pcLastTickAt = DateTime.now();
  }

  void _subtractTime() {
    final next = (_secondsRemaining - _addStepSeconds).clamp(0, 1 << 30);
    setState(() => _secondsRemaining = next);
    SessionState.pcRemainingSeconds = _secondsRemaining;
    if (!_paused) SessionState.pcLastTickAt = DateTime.now();
  }

  void _stopTime() {
    setState(() => _paused = !_paused);
    SessionState.pcPaused = _paused;
    SessionState.pcLastTickAt = _paused ? null : DateTime.now();
  }

  void _endSession() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'END SESSION?',
                style: AppTextStyles.sectionTitle
                    .copyWith(color: AppColors.background),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to end your gaming session?',
                style:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.overlay),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(ctx).pop(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'CANCEL',
                          style: AppTextStyles.button
                              .copyWith(color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ByxexButton(
                      label: 'END',
                      onTap: () {
                        SessionState.endPcSession();
                        Navigator.of(ctx).pop();
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callAdmin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.card,
        content: Text(
          'Admin has been notified!',
          style: AppTextStyles.bodyLarge,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'PC SETTINGS'),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 48, 28, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── TIME LEFT — rounded rectangular card ──────────────
                      Center(
                        child: SizedBox(
                          width: 200,
                          height: 110,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Opacity(
                                opacity: 0.50,
                                child: Image.asset(
                                  'assets/images/pc_time_card_bg.png',
                                  fit: BoxFit.fill,
                                  errorBuilder: (_, __, ___) =>
                                      _DarkCardFallback(),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'TIME LEFT',
                                      style: TextStyle(
                                        fontFamily: 'BlackHanSans',
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 2.5,
                                        height: 1,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _format(_secondsRemaining),
                                      style: TextStyle(
                                        fontFamily: 'BlackHanSans',
                                        fontSize: 36,
                                        color: _paused
                                            ? AppColors.warning
                                            : Colors.white,
                                        letterSpacing: 2,
                                        height: 1,
                                      ),
                                    ),
                                    if (_paused)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: Text(
                                          'PAUSED',
                                          style: TextStyle(
                                            fontFamily: 'BlackHanSans',
                                            fontSize: 12,
                                            color: AppColors.warning,
                                            letterSpacing: 2,
                                            height: 1,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 44),

                      // ── ADD TIME label ────────────────────────────────────
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ADD TIME',
                          style: TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 2,
                            height: 1,
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 80.ms),

                      const SizedBox(height: 16),

                      // ── ADD TIME container ────────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Opacity(
                              opacity: 0.50,
                              child: Image.asset(
                                'assets/images/pc_add_time_bg.png',
                                fit: BoxFit.fill,
                                errorBuilder: (_, __, ___) =>
                                    _DarkCardFallback(),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 22),
                              child: Row(
                                children: [
                                  const Text(
                                    '30 min',
                                    style: TextStyle(
                                      fontFamily: 'BlackHanSans',
                                      fontSize: 18,
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      height: 1,
                                    ),
                                  ),
                                  const Spacer(),
                                  _PlusMinusBtn(
                                      icon: Icons.add, onTap: _addTime),
                                  const SizedBox(width: 14),
                                  _PlusMinusBtn(
                                      icon: Icons.remove,
                                      onTap: _subtractTime),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 140.ms),

                      const SizedBox(height: 32),

                      // ── Action buttons (image-only assets) ────────────────
                      _LightningButton(
                        asset: 'assets/images/pc_btn_stop_time.png',
                        fallbackLabel: _paused ? 'RESUME TIME' : 'STOP TIME',
                        onTap: _stopTime,
                        index: 0,
                      ),
                      const SizedBox(height: 14),
                      _LightningButton(
                        asset: 'assets/images/pc_btn_end_session.png',
                        fallbackLabel: 'END SESSION',
                        onTap: _endSession,
                        index: 1,
                      ),
                      const SizedBox(height: 14),
                      _LightningButton(
                        asset: 'assets/images/pc_btn_call_admin.png',
                        fallbackLabel: 'CALL ADMIN',
                        onTap: _callAdmin,
                        index: 2,
                      ),

                      const Spacer(),
                      ByxexButton(
                        label: 'BACK',
                        onTap: () => context.pop(),
                      ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
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

// Dark rounded card fallback when asset isn't available yet.
class _DarkCardFallback extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A2654), Color(0xFF0E1740)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}

class _PlusMinusBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _PlusMinusBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class _LightningButton extends StatelessWidget {
  final String asset;
  final String fallbackLabel;
  final VoidCallback onTap;
  final int index;
  const _LightningButton({
    required this.asset,
    required this.fallbackLabel,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: Image.asset(
          asset,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => Stack(
            fit: StackFit.expand,
            children: [
              _DarkCardFallback(),
              Center(
                child: Text(
                  fallbackLabel,
                  style: const TextStyle(
                    fontFamily: 'BlackHanSans',
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 2,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 350.ms,
          delay: Duration(milliseconds: 200 + index * 60),
        );
  }
}
