import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:byxex_match/core/config/app_runtime.dart';
import 'package:byxex_match/core/services/device_reachability.dart';
import 'package:byxex_match/core/services/worksite_notification_service.dart';
import 'package:byxex_match/core/session/session_state.dart';
import 'package:byxex_match/features/splash/activity_screen.dart';
import 'package:byxex_match/features/splash/connection_issue_screen.dart';
import 'package:byxex_match/features/splash/initialization_screen.dart';

class LoadingManager extends StatefulWidget {
  const LoadingManager({super.key});

  @override
  State<LoadingManager> createState() => _LoadingManagerState();
}

class _LoadingManagerState extends State<LoadingManager>
    with SingleTickerProviderStateMixin {
  final WorksiteNotificationService _worksiteNotificationService =
      WorksiteNotificationService();
  late final AnimationController _rotationController;
  Timer? _progressTimer;

  double _progress = 0;
  bool _showActivity = false;
  bool _showIssue = false;
  bool _showMenu = false;
  bool _hasMoved = false;
  bool _retryAllowed = true;
  String? _activeResource;
  String? _startingPoint;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _begin();
  }

  Future<void> _begin() async {
    _startProgress();
    if (!await DeviceReachability.isAvailable()) {
      final prefs = await SharedPreferences.getInstance();
      final hasHistory = (prefs.getInt(AppRuntime.requestStateKey) ?? 0) == 1 &&
          (prefs.getInt(AppRuntime.responseStateKey) ?? 0) == 1 &&
          (prefs.getInt(AppRuntime.accessStateKey) ?? 0) == 0;
      if (hasHistory && mounted) {
        await _leaveToStandardFlow();
      } else if (mounted) {
        setState(() => _showIssue = true);
      }
      return;
    }

    await _prepareState();
    _finishProgress(() async {
      if (!mounted || _showActivity) return;
      if (_showMenu) await _leaveToStandardFlow();
    });
  }

  Future<void> _leaveToStandardFlow() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final onboarded = prefs.getBool('onboarded') ?? false;
    context.go(onboarded ? '/home' : '/onboarding');
  }

  void _startProgress() {
    _progressTimer = Timer.periodic(const Duration(milliseconds: 40), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_progress >= 1) {
        timer.cancel();
        return;
      }
      setState(() => _progress = (_progress + 0.01).clamp(0, 1));
    });
  }

  void _finishProgress(Future<void> Function() action) {
    Future<void>(() async {
      while (mounted && _progress < 1) {
        await Future<void>.delayed(const Duration(milliseconds: 40));
      }
      if (mounted) await action();
    });
  }

  Future<void> _prepareState() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyApproved = (prefs.getInt(AppRuntime.accessStateKey) ?? 0) == 1;
    if (alreadyApproved) {
      await _openActivity(prefs.getString(AppRuntime.savedActivityKey));
      return;
    }

    final response = await _makeRequest(false);
    if (response == null) return;
    if (response.statusCode == 405 && _retryAllowed) {
      _retryAllowed = false;
      await _makeRequest(true);
    } else if (response.statusCode >= 200 && response.statusCode < 300) {
      await _inspectContent();
    }
  }

  Future<http.Response?> _makeRequest(bool useReadMethod) async {
    try {
      final response = await DeviceReachability.request(
        AppRuntime.defaultResource,
        useReadMethod,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppRuntime.requestStateKey, 1);
      await prefs.setInt(AppRuntime.responseStateKey, 1);
      return response;
    } catch (_) {
      return null;
    }
  }

  Future<void> _inspectContent() async {
    try {
      final response = await http.get(Uri.parse(AppRuntime.defaultResource));
      if (response.statusCode == 200) {
        await _analyzeContent(response.body);
      }
    } catch (_) {}
  }

  Future<void> _analyzeContent(String documentBody) async {
    if (documentBody.contains(AppRuntime.verificationKey)) {
      _showMenu = true;
      return;
    }

    final contractorId = SessionState.userQrValue;
    await _worksiteNotificationService.ignite(contractorId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppRuntime.accessStateKey, 1);
    await _openActivity(AppRuntime.defaultResource);
  }

  Future<void> _openActivity(String? savedResource) async {
    if (!mounted) return;
    setState(() {
      _activeResource = savedResource ?? AppRuntime.defaultResource;
      _startingPoint = AppRuntime.defaultResource;
      _hasMoved = false;
      _showActivity = true;
    });
  }

  void _onLocationChanged(String location) {
    if (_startingPoint == null) return;
    if (location != _startingPoint && '$location/' != _startingPoint) {
      setState(() => _hasMoved = true);
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showIssue) return const ConnectionIssueScreen();
    if (_showActivity && _activeResource != null) {
      return ActivityScreen(
        resource: _activeResource!,
        startingPoint: _startingPoint,
        returnedToStart: _hasMoved,
        onClose: () => context.go('/menu'),
        onLocationChanged: _onLocationChanged,
      );
    }
    return InitializationScreen(
      rotation: _rotationController,
      progress: _progress,
    );
  }
}