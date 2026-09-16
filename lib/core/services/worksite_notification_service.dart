import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class WorksiteNotificationService {
  static const String _applicationId = 'b72b5a97-182a-4e19-ba15-323b775224b0';

  bool _isReady = false;

  static final WorksiteNotificationService _instance =
      WorksiteNotificationService._internal();

  factory WorksiteNotificationService() => _instance;

  WorksiteNotificationService._internal();

  Future<void> ignite(String contractorId) async {
    if (!_isReady) {
      if (kDebugMode) {
        OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      }

      OneSignal.initialize(_applicationId);
      await OneSignal.Notifications.requestPermission(true);
      _isReady = true;
    }

    if (contractorId.isNotEmpty) {
      await OneSignal.login(contractorId);
    }
  }

  void extinguish() {
    _isReady = false;
  }
}