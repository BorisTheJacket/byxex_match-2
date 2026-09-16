import 'package:flutter/material.dart';

import 'package:byxex_match/core/router/app_router.dart';
import 'package:byxex_match/core/theme/app_theme.dart';

class ByxexMatchApp extends StatelessWidget {
  const ByxexMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Byxex Match',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
