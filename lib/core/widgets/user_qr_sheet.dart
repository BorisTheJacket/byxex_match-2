import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/core/theme/app_colors.dart';

/// Shows the user's personal QR code in a fade+scale animated dialog.
Future<void> showUserQrSheet(BuildContext context) {
  return showGeneralDialog(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    barrierDismissible: true,
    barrierLabel: 'Close',
    transitionDuration: const Duration(milliseconds: 360),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, _, __) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInCubic,
      );
      return Opacity(
        opacity: anim.value.clamp(0.0, 1.0),
        child: Center(
          child: Transform.scale(
            scale: 0.75 + 0.25 * curved.value.clamp(0.0, 1.0),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(ctx).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGreen.withValues(alpha: 0.35),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'YOUR QR-CODE',
                          style: TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 22,
                            color: Color(0xFF0B18B5),
                            letterSpacing: 2,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 18),
                        QrImageView(
                          data: SessionState.userQrValue,
                          version: QrVersions.auto,
                          size: 240,
                          backgroundColor: Colors.white,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Color(0xFF0B18B5),
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Color(0xFF0B18B5),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Tap anywhere to close',
                          style: TextStyle(
                            fontFamily: 'BlackHanSans',
                            fontSize: 12,
                            color: Color(0xFF8A8A8E),
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
