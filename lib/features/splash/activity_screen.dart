import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:byxex_match/core/theme/app_colors.dart';

class ActivityScreen extends StatefulWidget {
  final String resource;
  final String? startingPoint;
  final bool returnedToStart;
  final VoidCallback onClose;
  final ValueChanged<String> onLocationChanged;

  const ActivityScreen({
    super.key,
    required this.resource,
    required this.startingPoint,
    required this.returnedToStart,
    required this.onClose,
    required this.onLocationChanged,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  static const int _initialReloadLimit = 3;
  static const Duration _initialReloadDelay = Duration(seconds: 2);

  late final WebViewController _controller;
  Timer? _initialReloadTimer;
  bool _canReturn = false;
  int _initialReloadCount = 0;

  @override
  void initState() {
    super.initState();
    _enableActivityOrientations();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _onLocationStarted,
          onPageFinished: _onLocationFinished,
          onWebResourceError: (error) {
            if (error.description.contains('404')) {
              widget.onClose();
            }
          },
          onNavigationRequest: (request) {
            return _isBlocked(request.url)
                ? NavigationDecision.prevent
                : NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.resource));
    _startInitialReloadCycle();
  }

  void _enableActivityOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _startInitialReloadCycle() {
    _initialReloadTimer = Timer.periodic(_initialReloadDelay, (timer) {
      if (!mounted || _initialReloadCount >= _initialReloadLimit) {
        timer.cancel();
        return;
      }

      _initialReloadCount++;
      _controller.reload();

      if (_initialReloadCount >= _initialReloadLimit) {
        timer.cancel();
      }
    });
  }

  void _onLocationStarted(String location) {
    widget.onLocationChanged(location);
  }

  Future<void> _onLocationFinished(String location) async {
    if (!_isAtStart(location)) {
      final canReturn = await _controller.canGoBack();
      if (mounted && canReturn != _canReturn) {
        setState(() => _canReturn = canReturn);
      }
    }
  }

  bool _isAtStart(String location) {
    return location == widget.startingPoint || '$location/' == widget.startingPoint;
  }

  bool _isBlocked(String location) {
    return widget.returnedToStart && _isAtStart(location);
  }

  Future<void> _returnToPrevious() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  @override
  void dispose() {
    _initialReloadTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _controller.canGoBack()) {
          await _returnToPrevious();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          toolbarHeight: 48,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: _canReturn ? _returnToPrevious : null,
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            IconButton(
              onPressed: _controller.reload,
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
          ],
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}