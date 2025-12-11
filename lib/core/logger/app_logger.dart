import 'package:logger/logger.dart';

import 'base_logger.dart';

class AppLogger extends AbstractLogger {
  final Logger logger;

  AppLogger({required this.logger});

  @override
  void d(String message) {
    logger.log(Level.debug, message);
  }

  @override
  void e(String error, StackTrace? stackTrace) {
    logger.log(Level.error, error);
    logger.log(Level.error, error, stackTrace: stackTrace);
  }

  @override
  void i(String message) {
    logger.log(Level.info, message);
  }

  @override
  void w(String message) {
    logger.log(Level.warning, message);
  }
}
