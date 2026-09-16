import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:byxex_match/features/splash/loading_manager.dart';
import 'package:byxex_match/features/onboarding/onboarding_screen.dart';
import 'package:byxex_match/features/nickname/nickname_screen.dart';
import 'package:byxex_match/features/home/dashboard_screen.dart';
import 'package:byxex_match/features/menu/menu_screen.dart';
import 'package:byxex_match/features/prices/prices_screen.dart';
import 'package:byxex_match/features/profile/profile_screen.dart';
import 'package:byxex_match/features/about/about_screen.dart';
import 'package:byxex_match/features/pc_control/pc_control_screen.dart';
import 'package:byxex_match/features/qr_code/qr_code_screen.dart';
import 'package:byxex_match/features/booking/booking_form_screen.dart';
import 'package:byxex_match/features/events/events_screen.dart';
import 'package:byxex_match/features/games/games_screen.dart';
import 'package:byxex_match/features/promotions/promotions_screen.dart';
import 'package:byxex_match/features/tasks/tasks_screen.dart';

CustomTransitionPage<T> _slideRight<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
      final fade = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const LoadingManager()),
    ),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const OnboardingScreen()),
    ),
    GoRoute(
      path: '/nickname',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const NicknameScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const DashboardScreen()),
    ),
    GoRoute(
      path: '/menu',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const MenuScreen()),
    ),
    GoRoute(
      path: '/prices',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const PricesScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const ProfileScreen()),
    ),
    GoRoute(
      path: '/about',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const AboutScreen()),
    ),
    GoRoute(
      path: '/pc-control',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const PCControlScreen()),
    ),
    GoRoute(
      path: '/qr',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const QRCodeScreen()),
    ),
    GoRoute(
      path: '/booking',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const BookingFormScreen()),
    ),
    GoRoute(
      path: '/events',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const EventsScreen()),
    ),
    GoRoute(
      path: '/games',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const GamesScreen()),
    ),
    GoRoute(
      path: '/promotions',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const PromotionsScreen()),
    ),
    GoRoute(
      path: '/tasks',
      pageBuilder: (context, state) =>
          _slideRight(context: context, state: state, child: const TasksScreen()),
    ),
  ],
);
