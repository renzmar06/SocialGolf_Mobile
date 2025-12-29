import 'package:social_golf_app/bottomNavbar.dart';
import 'package:social_golf_app/src/auth/forgotPassword/forgotPassword.dart';
import 'package:social_golf_app/src/auth/signIn/signIn.dart';
import 'package:social_golf_app/src/auth/signUp/signUp.dart';
import 'package:social_golf_app/src/onboarding/screens/onboarding.dart';
import 'package:social_golf_app/src/shop/screens/shop.dart';
import 'package:social_golf_app/src/splash/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../src/CreateListing/screens/create_listing_screen.dart';
import '../../src/Event/createEvent/screens/create_event_screen.dart';
import '../../src/Event/eventDetails/screens/event_detail_screen.dart';
import '../../src/Event/eventList/screens/event_list_screen.dart';
import '../../src/Groups/GroupCreate/screens/create_group_screen.dart';
import '../../src/Groups/GroupDetils/screens/group_detail_screen.dart';
import '../../src/Groups/GroupsList/screens/groups_list_screen.dart';
import '../../src/ScoreTracker/screens/score_tracker_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SplashScreen();
      },
    ),
    GoRoute(
      path: '/bottom-navigation',
      builder: (BuildContext context, GoRouterState state) {
        final extra = state.extra as Map<String, dynamic>?;
        final initialIndex = extra != null
            ? extra['initialIndex'] as int? ?? 0
            : 0;
        return BottomNavbar(initialIndex: initialIndex);
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (BuildContext context, GoRouterState state) {
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: '/signin',
      builder: (BuildContext context, GoRouterState state) {
        return SignInScreen();
      },
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (BuildContext context, GoRouterState state) {
        return ForgotPasswordScreen();
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (BuildContext context, GoRouterState state) {
        return SignUpScreen();
      },
    ),
    GoRoute(
      path: '/shop',
      builder: (BuildContext context, GoRouterState state) {
        return ShopScreen();
      },
    ),
    GoRoute(
      path: '/CreateListing',
      builder: (BuildContext context, GoRouterState state) {
        return CreateListingScreen();
      },
    ),
    GoRoute(
      path: '/ScoreTracker',
      builder: (BuildContext context, GoRouterState state) {
        return ScoreTrackerScreen();
      },
    ),
    GoRoute(
      path: '/GroupsList',
      builder: (BuildContext context, GoRouterState state) {
        return GroupsListScreen();
      },
    ),
    GoRoute(
      path: '/CreateGroup',
      builder: (BuildContext context, GoRouterState state) {
        return CreateGroupScreen();
      },
    ),
    GoRoute(
      path: '/GroupDetail',
      builder: (BuildContext context, GoRouterState state) {
        return GroupDetailScreen(groupId: "1",);
      },
    ),
    GoRoute(
      path: '/EventList',
      builder: (BuildContext context, GoRouterState state) {
        return EventListScreen();
      },
    ),
    GoRoute(
      path: '/EventDetail',
      builder: (BuildContext context, GoRouterState state) {
        final eventId = state.pathParameters['eventId'] ?? '';
        return EventDetailScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/CreateEvent',
      builder: (BuildContext context, GoRouterState state) {
        return const CreateEventScreen();
      },
    ),
  ],
);
