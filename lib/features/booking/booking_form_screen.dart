import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/theme/app_text_styles.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

const _timeOptions = [
  '1 Hour',
  '3 Hours',
  '5 Hours',
  'All Day',
  'All Night',
  '1 Hour of Ps',
];

class BookingFormScreen extends StatefulWidget {
  final String? preselectedClub;
  const BookingFormScreen({super.key, this.preselectedClub});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_refresh);
    _phoneController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  bool get _isValid =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _selectedTime != null;

  Future<void> _pickTime() async {
    final value = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _timeOptions
              .map(
                (t) => ListTile(
                  title: Text(
                    t,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'BlackHanSans',
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  onTap: () => Navigator.of(ctx).pop(t),
                ),
              )
              .toList(),
        ),
      ),
    );
    if (value != null) setState(() => _selectedTime = value);
  }

  Future<void> _submit() async {
    if (!_isValid) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CONFIRMED!',
                style: AppTextStyles.sectionTitle
                    .copyWith(color: AppColors.background),
              ),
              const SizedBox(height: 12),
              Text(
                'Booking confirmed! See you at the club.',
                style: AppTextStyles.bodyMedium
                    .copyWith(color: AppColors.overlay),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ByxexButton(
                  label: 'OK',
                  onTap: () {
                    Navigator.of(ctx).pop();
                    context.pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'BOOKING PC'),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Club photo ───────────────────────────────────────
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: AspectRatio(
                          aspectRatio: 1.7,
                          child: Image.asset(
                            'assets/images/about_club.png',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.card,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.storefront_rounded,
                                color: AppColors.accentCyan,
                                size: 60,
                              ),
                            ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .slideY(begin: 0.1, curve: Curves.easeOutCubic),

                      const SizedBox(height: 14),

                      const Text(
                        'Andrássy út 60, 1061 Budapest, Hungary',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamilyFallback: ['SF Pro Display', 'Roboto', 'Arial'],
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.3,
                          height: 1.35,
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                      const SizedBox(height: 22),

                      // NAME
                      _FieldLabel(text: 'NAME', delay: 160.ms),
                      const SizedBox(height: 6),
                      _PillField(
                        controller: _nameController,
                        hint: 'Enter your name',
                        delay: 180.ms,
                      ),

                      const SizedBox(height: 18),

                      // PHONE
                      _FieldLabel(text: 'PHONE NUMBER', delay: 220.ms),
                      const SizedBox(height: 6),
                      _PillField(
                        controller: _phoneController,
                        hint: '+1 XXX XXX XXXX',
                        keyboardType: TextInputType.phone,
                        delay: 240.ms,
                      ),

                      const SizedBox(height: 18),

                      // SELECT TIME
                      _FieldLabel(text: 'SELECT TIME', delay: 280.ms),
                      const SizedBox(height: 6),
                      _PillDropdown(
                        value: _selectedTime,
                        hint: 'Select time',
                        onTap: _pickTime,
                        delay: 300.ms,
                      ),

                      const SizedBox(height: 28),

                      _NextButton(
                        enabled: _isValid,
                        onTap: _submit,
                      ).animate().fadeIn(duration: 400.ms, delay: 360.ms),
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

// ── Helpers ────────────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  final Duration delay;
  const _FieldLabel({required this.text, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'BlackHanSans',
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1.0,
          height: 1,
        ),
      ),
    ).animate().fadeIn(duration: 380.ms, delay: delay).slideX(
          begin: -0.08,
          curve: Curves.easeOutCubic,
        );
  }
}

class _PillField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final Duration delay;

  const _PillField({
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
        ),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'BlackHanSans',
          fontSize: 17,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 0.8,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'BlackHanSans',
            fontSize: 16,
            color: Colors.white.withValues(alpha: 0.55),
            letterSpacing: 0.6,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          isCollapsed: true,
        ),
      ),
    ).animate().fadeIn(duration: 380.ms, delay: delay).slideY(
          begin: 0.08,
          curve: Curves.easeOutCubic,
        );
  }
}

class _PillDropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final VoidCallback onTap;
  final Duration delay;

  const _PillDropdown({
    required this.value,
    required this.hint,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const SizedBox(width: 24),
            Expanded(
              child: Text(
                value ?? hint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BlackHanSans',
                  fontSize: value != null ? 17 : 16,
                  fontWeight: FontWeight.w900,
                  color: value != null
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.55),
                  letterSpacing: 0.8,
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.white.withValues(alpha: 0.75),
              size: 24,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 380.ms, delay: delay).slideY(
          begin: 0.08,
          curve: Curves.easeOutCubic,
        );
  }
}

class _NextButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;
  const _NextButton({required this.enabled, required this.onTap});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: enabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 56,
          decoration: BoxDecoration(
            gradient: enabled ? AppColors.greenButtonGradient : null,
            borderRadius: BorderRadius.circular(28),
            border: enabled
                ? null
                : Border.all(color: Colors.white.withValues(alpha: 0.35)),
          ),
          alignment: Alignment.center,
          child: Text(
            'NEXT',
            style: TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 18,
              color: enabled
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.45),
              letterSpacing: 1.5,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
