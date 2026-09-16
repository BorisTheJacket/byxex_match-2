import 'dart:math';

// In-memory session state. Resets on app restart.
class SessionState {
  // Long, unique-per-session identifier baked into the user's personal QR code.
  // Format consumed elsewhere: "byxex_user_<id>".
  static String? _userQrId;
  static String get userQrValue {
    _userQrId ??= _generateLongId();
    return 'byxex_user_$_userQrId';
  }

  static String _generateLongId() {
    final rnd = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return String.fromCharCodes(
      List.generate(
          24, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }

  // True after the user successfully scans a valid Byxex club QR code
  // (pattern: byxex_club_<digits>) this app session.
  static bool qrVerified = false;

  // PC session time — persists across screen navigations within an app session.
  // Starts at 0; grows when the user adds time via PC Control.
  static int pcRemainingSeconds = 0;
  static bool pcPaused = false;
  // When the timer was last ticked; used to catch up missed seconds while
  // the PC Control screen wasn't on top.
  static DateTime? pcLastTickAt;

  // Catch up time elapsed while away from the PC Control screen.
  static void syncPcTime() {
    if (pcPaused || pcRemainingSeconds <= 0 || pcLastTickAt == null) {
      return;
    }
    final elapsed = DateTime.now().difference(pcLastTickAt!).inSeconds;
    if (elapsed > 0) {
      pcRemainingSeconds = (pcRemainingSeconds - elapsed).clamp(0, 1 << 30);
      pcLastTickAt = DateTime.now();
    }
  }

  // Loyalty points shown on the home dashboard and profile screen.
  static int userPoints = 0;

  // True after the user has answered the camera permission prompt at least
  // once this session — used to avoid re-prompting on every QR screen visit.
  static bool cameraPermissionAsked = false;

  // End the gaming session — clears time and revokes QR access for this session.
  static void endPcSession() {
    pcRemainingSeconds = 0;
    pcPaused = false;
    pcLastTickAt = null;
    qrVerified = false;
  }
}
