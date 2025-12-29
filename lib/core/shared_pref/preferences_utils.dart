import 'package:shared_preferences/shared_preferences.dart';

import '../logger/app_logger.dart';
import '../network/network_call/data/model/login_response.dart';
import 'constants.dart';

class PreferencesUtil {
  final SharedPreferences preferences;
  final AppLogger logger;

  PreferencesUtil({required this.preferences, required this.logger});

  getPreferencesData(String key) {
    return preferences.get(key) ?? "";
  }

  getPreferencesListData(String key) {
    return preferences.getStringList(key) ?? [];
  }

  getPreferencesDoubleData(String key) {
    return preferences.getDouble(key) ?? 0.0;
  }

  getPreferencesIntData(String key) {
    return preferences.getInt(key) ?? 0;
  }

  getBoolPreferencesData(String key) {
    return preferences.get(key) ?? false;
  }

  bool containKey(String key) {
    return preferences.containsKey(key);
  }

  setPreferencesData(String key, String? value) {
    logger.i('$runtimeType   setPreferencesData KEY: $key');
    logger.i('$runtimeType   setPreferencesData VALUE: $value');
    preferences.setString(key, value ?? "");
  }

  setPreferencesListData(String key, List<String> value) {
    logger.i('$runtimeType   setPreferencesData KEY: $key');
    logger.i('$runtimeType   setPreferencesData VALUE: $value');
    preferences.setStringList(key, value);
  }

  setPreferencesDoubleData(String key, double? value) {
    logger.i('$runtimeType   setPreferencesDoubleData KEY: $key');
    logger.i('$runtimeType   setPreferencesDoubleData VALUE: $value');
    preferences.setDouble(key, value ?? 0.0);
  }

  setPreferencesIntData(String key, int? value) {
    logger.i('$runtimeType   setPreferencesDoubleData KEY: $key');
    logger.i('$runtimeType   setPreferencesDoubleData VALUE: $value');
    preferences.setInt(key, value ?? 0);
  }

  setBoolPreferencesData(String key, bool? value) {
    logger.i('$runtimeType   setBoolPreferencesData KEY: $key');
    logger.i('$runtimeType   setBoolPreferencesData VALUE: $value');
    preferences.setBool(key, value ?? false);
  }

  removePreferencesData(String key) async {
    await preferences.remove(key);
  }

  Future<void> clearPreferencesData({List<String>? preserveKeys}) async {
    if (preserveKeys != null && preserveKeys.isNotEmpty) {
      final allKeys = preferences.getKeys();
      for (final key in allKeys) {
        if (!preserveKeys.contains(key)) {
          await preferences.remove(key);
          logger.i('$runtimeType   clearPreferencesData REMOVED KEY: $key');
        }
      }
    } else {
      await preferences.clear();
      logger.i('$runtimeType   clearPreferencesData CLEARED ALL');
    }
  }

  Future<void> saveLoginData(LoginResponse data) async {
    logger.i("Saving login data...");

    await setPreferencesData(Constants.accessToken, data.token);

    final user = data.user;
    if (user != null) {
      await setPreferencesData(Constants.preCustomerIdKey, user.id);
      await setPreferencesData(Constants.prefNameKey, user.name);
      await setPreferencesData(Constants.prefEmailAddressKey, user.email);
      await setPreferencesData(Constants.prefRole, user.role);

      await setBoolPreferencesData(Constants.prefIsLoggedIn, true);
      await setBoolPreferencesData(Constants.prefIsisActive, user.isActive);
    }
  }
}
