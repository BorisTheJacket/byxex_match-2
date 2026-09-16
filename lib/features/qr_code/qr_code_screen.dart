import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/core/theme/app_colors.dart';
import 'package:byxex_match/core/widgets/screen_header.dart';

final RegExp _validQrPattern = RegExp(r'^byxex_club_\d+$');

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  State<QRCodeScreen> createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  late final MobileScannerController _controller;
  bool _scannerRequested = false;
  bool _scanned = false;
  bool _invalidShown = false;
  Timer? _invalidTimer;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: false,
      useNewCameraSelector: true,
    );
    _scannerRequested = SessionState.cameraPermissionAsked;
    if (_scannerRequested) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          unawaited(_controller.start());
        }
      });
    }
  }

  @override
  void dispose() {
    _invalidTimer?.cancel();
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _requestCameraAccess() async {
    if (!mounted) {
      return;
    }

    SessionState.cameraPermissionAsked = true;
    setState(() => _scannerRequested = true);

    await _controller.stop();
    await _controller.start();
  }

  Future<void> _retryCameraAccess() async {
    await _controller.stop();
    await _requestCameraAccess();
  }

  Widget _buildIntroCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Camera access is required',
            style: TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 16,
              color: Color(0xFF1A1A1A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'We use the camera to scan club QR codes and unlock the PC session.',
            style: TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 13,
              color: Color(0xFF6E6E73),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ByxexButton(
              label: 'CONTINUE',
              onTap: () => unawaited(_requestCameraAccess()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraError(MobileScannerException error) {
    final String message = error.errorCode ==
            MobileScannerErrorCode.permissionDenied
        ? 'Camera access is turned off. Enable it in Settings to scan QR codes.'
        : 'Camera unavailable right now. Please try again.';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Camera is unavailable',
            style: TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 16,
              color: Color(0xFF1A1A1A),
              height: 1.25,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontFamily: 'BlackHanSans',
              fontSize: 13,
              color: Color(0xFF6E6E73),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ByxexButton(
              label: 'TRY AGAIN',
              onTap: () => unawaited(_retryCameraAccess()),
            ),
          ),
        ],
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanned) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final value = barcodes.first.rawValue ?? '';
    if (value.isEmpty) return;

    if (_validQrPattern.hasMatch(value)) {
      SessionState.qrVerified = true;
      setState(() => _scanned = true);
    } else {
      if (_invalidShown) return;
      setState(() => _invalidShown = true);
      _invalidTimer?.cancel();
      _invalidTimer = Timer(const Duration(seconds: 2), () {
        if (mounted) setState(() => _invalidShown = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ByxexBackground(
        child: SafeArea(
          child: Column(
            children: [
              const ByxexHeader(title: 'QR-CODE'),
              const SizedBox(height: 36),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.accentGreen,
                        width: 3,
                      ),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: AnimatedSwitcher(
                      duration: 300.ms,
                      child: !_scannerRequested
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: _buildIntroCard(),
                              ),
                            )
                          : MobileScanner(
                              controller: _controller,
                              onDetect: _onDetect,
                              errorBuilder: (context, error, child) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: _buildCameraError(error),
                                  ),
                                );
                              },
                            ),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ),
              ),
              const Spacer(),
              if (_invalidShown && !_scanned)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: const Text(
                      'Invalid QR code.\nPlease scan a Byxex club code.',
                      style: TextStyle(
                        fontFamily: 'BlackHanSans',
                        fontSize: 15,
                        color: Color(0xFFB00020),
                        height: 1.3,
                      ),
                    ),
                  ).animate().fadeIn(duration: 200.ms),
                ),
              if (_scanned)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(bottom: 14),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Your PC has been activated.\nEnjoy the game!',
                          style: TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 16,
                            color: Color(0xFF1A1A1A),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ByxexButton(
                            label: 'Ok',
                            onTap: () {
                              context.pushReplacement('/pc-control');
                            },
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 250.ms).slideY(
                        begin: 0.1,
                        end: 0,
                        duration: 250.ms,
                        curve: Curves.easeOut,
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
