// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/local%20storage/storage_utility.dart';
import 'package:social_golf_app/core/localization/locale_constants.dart';
import 'package:social_golf_app/core/localization/localizations_delegate.dart';
import 'package:social_golf_app/core/network/network_call/api_config.dart';
import 'package:social_golf_app/core/services/go_router_service.dart';
import 'package:social_golf_app/core/utils/constants/colors.dart';
import 'package:social_golf_app/core/utils/notifcations/localNotification.dart';
import 'package:social_golf_app/core/utils/size_config.dart';
import 'package:social_golf_app/core/utils/theme/theme.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint("Handling a background message: ${message.data}");
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await TLocalStorage.init('appBox');

  // Initialize Firebase
  // await Firebase.initializeApp();

  // Set the background messaging handler
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request permission for notifications
  // await FirebaseMessaging.instance.requestPermission();

  // Initialize dependency injection
  await initDi();

  // Initialize Firebase tokens (non-blocking, so no await)
  // initFbToken();
  // Stripe.publishableKey = PublishableKey;
  // await Stripe.instance.applySettings();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // await initPusher();
  // await initPusherBeams();

  runApp(
    OverlaySupport.global(
      // child: MultiBlocProvider(
      //   providers: [
      //     // BlocProvider(
      //     //   create: (context) => serviceLocator<CartCubit>(),
      //     // ), // Provide CartCubit globally
      //     // BlocProvider(
      //     //   create: (_) => serviceLocator<LoginCubit>(),
      //     // ), // ✅ Add this
      //   ],
      //   child: MyApp(),
      // ),
      child: MyApp(),
    ),
  );
}

// initFbToken() async {
//   FirebaseMessaging.instance.getAPNSToken().then((String? apnsToken) {
//     debugPrint("APNSToken:>>> $apnsToken");
//   });
//   FirebaseMessaging.instance.getToken().then((String? fcmToken) {
//     debugPrint("FirebaseToken:>>> $fcmToken");
//     final pref = serviceLocator<PreferencesUtil>();
//     pref.setPreferencesData(Constants.fcmToken, fcmToken);
//   });
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocales(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalNotifications localNotifications = LocalNotifications();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            ColorConstants.brown, // Set the color of the navigation bar
        systemNavigationBarIconBrightness:
            Brightness.light, // Set icons to light/dark
      ),
    );
    requestStoragePermission();
    // FirebaseMessaging.instance.getInitialMessage().then((
    //   RemoteMessage? message,
    // ) async {
    //   if (message != null) {
    //     debugPrint("App opened from terminated state via notification click");
    //     _handleMessage(message);
    //   }
    // });

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    //   debugPrint("Received a foreground message: $message");
    //   localNotifications.showNotificationLatest(
    //     message.notification!.title ?? "",
    //     message.notification!.body ?? "",
    //   );
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   _handleMessage(message);
    // });
  }

  Future<void> requestStoragePermission() async {
    // Request storage permission
    var status = await Permission.storage.request();

    if (status.isGranted) {
      debugPrint("Storage permission granted");
    } else if (status.isDenied) {
      debugPrint("Storage permission denied");
      // Optionally, show a dialog to inform the user
    } else if (status.isPermanentlyDenied) {
      debugPrint("Storage permission permanently denied");
      // Guide user to app settings
      await openAppSettings();
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      commonLocal = locale;
    });
  }

  // void _handleMessage(RemoteMessage message) async {
  //   // Add any navigation or handling logic here if needed
  // }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        commonLocal = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SizeConfig().init(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        top: false,
        bottom: true,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Social Golf',
          theme: AppTheme.lightTheme,
          routerConfig: router,
          builder: EasyLoading.init(
            builder: (ctx, child) {
              EasyLoading.instance
                ..displayDuration = const Duration(milliseconds: 1000)
                ..indicatorColor = Colors.red
                ..maskColor = Colors.red
                ..userInteractions = false;
              return child!;
            },
          ),
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
            Locale('fr', ''),
            Locale('hi', ''),
            Locale('ne', ''),
            Locale('bn', ''),
            Locale('zh', ''),
            Locale('ml', ''),
            Locale('ta', ''),
          ],
          localizationsDelegates: const [AppLocalizationsDelegate()],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      ),
    );
  }
}
