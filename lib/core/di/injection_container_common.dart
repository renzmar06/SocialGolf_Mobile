import 'dart:async';
import 'dart:io';
import 'package:social_golf_app/core/di/injection_container_cache.dart';
import 'package:social_golf_app/core/di/presentation_container.dart';
import 'package:social_golf_app/core/di/remote_container.dart';
import 'package:social_golf_app/core/logger/app_logger.dart';
import 'package:social_golf_app/core/network/network_call/api_config.dart';
import 'package:social_golf_app/core/network/network_call/network_client.dart';
import 'package:social_golf_app/core/network/network_call/network_info.dart';
import 'package:social_golf_app/core/shared_pref/constants.dart';
import 'package:dio/dio.dart';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../logger/pretty_dio_logger.dart';
import 'domain_container.dart';

final serviceLocator = GetIt.I;

Future<void> initDi() async {
  try {
    serviceLocator.allowReassignment = true;

    serviceLocator.registerLazySingleton(
      () => Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 5,
          lineLength: 50,
          colors: true,
          printEmojis: true,
        ),
      ),
    );

    serviceLocator.registerLazySingleton(
      () => AppLogger(logger: serviceLocator()),
    );

    serviceLocator.registerLazySingleton(() => NetworkInfo());

    // serviceLocator.registerLazySingleton(() => NotificationData());

    await initCacheDI();
    await initDio();

    initPresentationDI();
    initRemoteDI();
    initDomainDI();

    serviceLocator.registerLazySingleton(
      () => NetworkClient(dio: serviceLocator(), logger: serviceLocator()),
    );

    serviceLocator.registerLazySingleton(() => NetworkInfo());
  } catch (e, s) {
    debugPrint("Exception in  initDI $e");
    debugPrint("$s");
  }
}

Future<void> initDio() async {
  try {
    Dio dio = Dio();

    BaseOptions baseOptions = BaseOptions(
      receiveTimeout: const Duration(minutes: 3),
      connectTimeout: const Duration(minutes: 3),
      headers: {HttpHeaders.userAgentHeader: 'dio', 'api': '1.0,0'},
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      baseUrl: ApiConfig.domain,
      // fixme: will do flavour based
      maxRedirects: 2,
    );
    dio.options = baseOptions;

    dio.interceptors.clear();

    dio.interceptors.add(
      PrettyDioLogger(
        requestBody: kDebugMode,
        error: kDebugMode,
        request: kDebugMode,
        compact: kDebugMode,
        maxWidth: 90,
        requestHeader: kDebugMode,
        responseBody: kDebugMode,
        responseHeader: kDebugMode,
        // logPrint: (o) {},
      ),
    );

    dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onError: (DioException error, handler) async {
          return handler.next(error);
        },
        onRequest: (RequestOptions requestOptions, handler) async {
          /// fixme: will change With Upper when Prefenece is done
          final SharedPreferences preferences =
              await SharedPreferences.getInstance();
          var accessToken = preferences.getString(Constants.accessToken);

          if (accessToken != "" || accessToken != null) {
            var authHeader = {'Authorization': 'Bearer $accessToken'};
            requestOptions.headers.addAll(authHeader);
          }

          var authHeader = {
            'x-device-id': commonDeviceID,
            'Accept-Language': 'en',
          };
          requestOptions.headers.addAll(authHeader);

          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
      ),
    );
    if (serviceLocator.isRegistered<Dio>()) {
      await serviceLocator.unregister<Dio>();
    }

    serviceLocator.registerLazySingleton(() => dio);
  } catch (e, s) {
    debugPrint("Exception in  initDIO $e");
    debugPrint("$s");
  }
}
