import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/logger/app_logger.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initCacheDI() async {
  final sharedPref = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPref);
  serviceLocator.registerLazySingleton<PreferencesUtil>(
    () => PreferencesUtil(preferences: sharedPref, logger: serviceLocator()),
  );
}

Future<void> initCacheForBackground() async {
  final sharedPref = await SharedPreferences.getInstance();

  serviceLocator.registerLazySingleton<SharedPreferences>(() => sharedPref);
  serviceLocator.registerLazySingleton(
    () => AppLogger(logger: serviceLocator()),
  );
  serviceLocator.registerLazySingleton<PreferencesUtil>(
    () => PreferencesUtil(
      preferences: sharedPref,
      logger: AppLogger(logger: Logger()),
    ),
  );
}
