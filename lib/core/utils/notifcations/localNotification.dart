import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotifications {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// A notification action which triggers a url launch event
  static String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static String navigationActionId = 'id_3';

  /// Defines a iOS/MacOS notification category for text input actions.
  static String darwinNotificationCategoryText = 'textCategory';

  /// Defines a iOS/MacOS notification category for plain actions.
  static String darwinNotificationCategoryPlain = 'plainCategory';

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  LocalNotifications() {
    setNotification();
  }

  Future<void> setNotification() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> showNotificationLatest(String title, String body) async {
    int notificationId =
        (DateTime.now().millisecondsSinceEpoch % 2147483647).toInt();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '1',
      'ok fine',
      icon: '@mipmap/ic_launcher',
      // enableLights: true,
      // colorized: false,
      showWhen: false,
      priority: Priority.high,
      importance: Importance.max,
      // color: Color.fromARGB(255, 240, 95, 0),
    );

    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificationId, title, body, platformChannelSpecifics,
        payload: title);
  }

  Future<void> showNotification(String title, String body, type) async {
    int notificationId =
        (DateTime.now().millisecondsSinceEpoch % 2147483647).toInt();

    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '1',
      'ok fine',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
      icon: '@mipmap/ic_launcher',
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        notificationId, title, body, platformChannelSpecifics,
        payload: type);
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    if (notificationResponse.payload != null) {
      // get foreground message here is print value
    }
  }

  Future<void> requestNotificationPermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      // The permission is already granted.
      debugPrint("Notification permission is already granted.");
    } else if (status.isDenied) {
      // The permission is denied.
      debugPrint("Notification permission is denied. Requesting permission...");
      status = await Permission.notification.request();
      if (status.isGranted) {
        debugPrint("Notification permission granted.");
      } else if (status.isDenied) {
        debugPrint("Notification permission denied.");
      } else if (status.isPermanentlyDenied) {
        debugPrint(
            "Notification permission is permanently denied. Opening app settings...");
        openAppSettings();
      }
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle iOS local notification received while app is in the foreground
    debugPrint('notification payload: $payload');
  }
}
