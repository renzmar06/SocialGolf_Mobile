import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/shared_pref/constants.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class NetworkInfo {
  final Connectivity _connectivity = Connectivity();
  bool isConnected = false;
  final prefs = serviceLocator<PreferencesUtil>();

  NetworkInfo() {
    startConnectivityListener();
    checkIsConnected().then((value) {
      isConnected = value;
    });
  }

  Future<bool> checkIsConnected() async {
    final List<ConnectivityResult> connectivityResult = await _connectivity
        .checkConnectivity();
    isConnected = hasAnyConnectivity(connectivityResult);
    return hasAnyConnectivity(connectivityResult);
  }

  StreamSubscription startConnectivityListener() {
    return _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      isConnected = hasAnyConnectivity(result);
      debugPrint('NetworkInfo:21 $isConnected');
      if (!isConnected) {
        if (!prefs.getBoolPreferencesData(Constants.prefInternetCheck)) {
          prefs.setBoolPreferencesData(Constants.prefInternetCheck, true);
          showSimpleNotification(
            const Row(
              children: [
                Icon(Icons.signal_cellular_connected_no_internet_4_bar),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Internet Connection!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Please check your internet connection and try again.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            background: Colors.red,
            slideDismissDirection: DismissDirection.up,
            position: NotificationPosition.top,
            duration: const Duration(seconds: 4),
          );
        }
      } else {
        if (prefs.getBoolPreferencesData(Constants.prefInternetCheck)) {
          prefs.setBoolPreferencesData(Constants.prefInternetCheck, false);
          showSimpleNotification(
            const Row(
              children: [
                Icon(Icons.signal_cellular_4_bar),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Internet Connection!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Internet Connection Successful!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            background: Colors.green,
            slideDismissDirection: DismissDirection.up,
            position: NotificationPosition.top,
            duration: const Duration(seconds: 4),
          );
        }
      }
    });
  }

  bool hasAnyConnectivity(List<ConnectivityResult> connectivityResults) {
    if (connectivityResults.contains(ConnectivityResult.wifi)) {
      return true;
    }
    if (connectivityResults.contains(ConnectivityResult.mobile)) {
      return true;
    }
    if (connectivityResults.contains(ConnectivityResult.ethernet)) {
      return true;
    }
    return false;
  }
}
