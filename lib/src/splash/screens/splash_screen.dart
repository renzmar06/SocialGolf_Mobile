import 'dart:async';
import 'package:rive/rive.dart';
import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/shared_pref/constants.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:social_golf_app/core/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  final Map<String, dynamic>?
  extra; // Properly declare extra as a named parameter

  const SplashScreen({super.key, this.extra}); // Correct constructor

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // FirebaseMessaging.instance.getAPNSToken().then((String? apnsToken) {
    //   debugPrint("APNSToken:>>> $apnsToken");
    // });
    // FirebaseMessaging.instance.getToken().then((String? fcmToken) {
    //   debugPrint("FirebaseToken:>>> $fcmToken");
    //   final pref = serviceLocator<PreferencesUtil>();
    //   pref.setPreferencesData(Constants.fcmToken, fcmToken);
    //   final isLoggedIn = pref.getBoolPreferencesData(Constants.prefIsLoggedIn);
    // if (isLoggedIn) {
    //   context.read<LoginCubit>().updateFcmToken(fcmToken);
    // }
    // });
    // Determine duration based on extra parameter
    final duration =
        widget.extra != null && widget.extra!.containsKey('duration')
        ? widget.extra!['duration'] as int
        : 4000; // Default to 4000ms (4 seconds)

    Timer(Duration(milliseconds: duration), () {
      final pref = serviceLocator<PreferencesUtil>();
      final prefShowHome = pref.getBoolPreferencesData(Constants.prefShowHome);
      if (prefShowHome) {
        context.go('/bottom-navbar', extra: {'initialIndex': 0});
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SizedBox(
            height: 300,
            width: 300,
            child: const RiveAnimation.asset(
              ImageStrings.riveIntro,
              fit: BoxFit.contain,
              // If your Rive file has a specific animation name, specify it here:
              // animations: ['Swing'],
            ),
          ),
        ),
      ),
    );
  }
}
