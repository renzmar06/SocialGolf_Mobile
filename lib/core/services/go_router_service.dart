import 'package:social_golf_app/src/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),

    // GoRoute(
    //   path: '/bottom-navbar',
    //   builder: (BuildContext context, GoRouterState state) {
    //     final extra = state.extra as Map<String, dynamic>?;
    //     final initialIndex =
    //         extra != null ? extra['initialIndex'] as int? ?? 0 : 0;
    //     return BottomNavbar(initialIndex: initialIndex);
    //   },
    // ),
  ],
);
