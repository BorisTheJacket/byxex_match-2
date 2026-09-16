import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/theme/app_text_styles.dart';

const _avatarAssets = [
  'assets/images/avatar_1.png',
  'assets/images/avatar_2.png',
  'assets/images/avatar_3.png',
  'assets/images/avatar_4.png',
  'assets/images/avatar_5.png',
];

class NicknameScreen extends StatefulWidget {
  const NicknameScreen({super.key});

  @override
  State<NicknameScreen> createState() => _NicknameScreenState();
}

class _NicknameScreenState extends State<NicknameScreen> {
  final _controller = TextEditingController();
  int _selectedAvatar = 0;
  bool _hasText = false;
  double _dragDx = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  void _nextAvatar() {
    setState(() {
      _selectedAvatar = (_selectedAvatar + 1) % _avatarAssets.length;
    });
  }

  void _prevAvatar() {
    setState(() {
      _selectedAvatar =
          (_selectedAvatar - 1 + _avatarAssets.length) % _avatarAssets.length;
    });
  }

  void _onDragStart(DragStartDetails _) {
    _dragDx = 0;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragDx += details.delta.dx;
  }

  void _onDragEnd(DragEndDetails details) {
    final vx = details.velocity.pixelsPerSecond.dx;
    // або достатньо рухнули пальцем/мишкою (>30px), або була інерція
    final distance = _dragDx;
    if (distance.abs() < 30 && vx.abs() < 100) return;
    final goNext = (distance != 0) ? distance < 0 : vx < 0;
    if (goNext) {
      _nextAvatar();
    } else {
      _prevAvatar();
    }
  }

  Future<void> _proceed() async {
    final nick = _controller.text.trim();
    if (nick.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nickname', nick);
    await prefs.setInt('avatar', _selectedAvatar);
    if (mounted) context.go('/home');
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
          Image.asset('assets/images/nickname_bg.png', fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                // HELLO text sits on top of the background image (no extra bg)
                Builder(builder: (ctx) {
                  final size = MediaQuery.of(ctx).size;
                  return Padding(
                    padding: EdgeInsets.only(
                      right: size.width * 0.052,
                      top: size.height * 0.05 - 15,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: size.width * 0.58,
                        child: FittedBox(
                          alignment: Alignment.centerRight,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'HELLO',
                            maxLines: 1,
                            style: AppTextStyles.screenTitle.copyWith(
                              fontSize: 30,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        // Велика зона для свайпу — захоплює увесь рядок,
                        // не лише сам аватар, щоб мишею/пальцем було легше.
                        GestureDetector(
                          onTap: _nextAvatar,
                          onHorizontalDragStart: _onDragStart,
                          onHorizontalDragUpdate: _onDragUpdate,
                          onHorizontalDragEnd: _onDragEnd,
                          behavior: HitTestBehavior.opaque,
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  transitionBuilder: (child, anim) =>
                                      ScaleTransition(scale: anim, child: child),
                                  child: Container(
                                    key: ValueKey(_selectedAvatar),
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0A0C1A),
                                      borderRadius: BorderRadius.circular(18),
                                      border: Border.all(
                                        color: AppColors.accentGreen,
                                        width: 2.5,
                                      ),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Image.asset(
                                      _avatarAssets[_selectedAvatar],
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person_rounded,
                                        color: AppColors.accentGreen,
                                        size: 80,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                // Dot indicators
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children:
                                      List.generate(_avatarAssets.length, (i) {
                                    final active = _selectedAvatar == i;
                                    return GestureDetector(
                                      onTap: () =>
                                          setState(() => _selectedAvatar = i),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        width: active ? 20 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: active
                                              ? AppColors.accentGreen
                                              : Colors.white
                                                  .withValues(alpha: 0.35),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms).scaleXY(
                            begin: 0.85, end: 1.0, duration: 400.ms),

                        const SizedBox(height: 28),

                        // Your name field
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Your name', style: AppTextStyles.bodyLarge),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _controller,
                              style: AppTextStyles.bodyLarge
                                  .copyWith(color: AppColors.textPrimary),
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                hintStyle: AppTextStyles.bodyLarge.copyWith(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                filled: true,
                                fillColor: AppColors.card,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      ],
                    ),
                  ),
                ),

                // NEXT button — disabled when empty
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                  child: GestureDetector(
                    onTap: _hasText ? _proceed : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _hasText
                            ? AppColors.greenButtonGradient
                            : const LinearGradient(
                                colors: [Color(0xFF1A2CD4), Color(0xFF0E1FCC)],
                              ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'NEXT',
                        style: AppTextStyles.button.copyWith(
                          color: _hasText
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
