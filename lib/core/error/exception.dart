import 'package:dio/dio.dart';

enum ErrorType {
  noInternet,
  bedRequest,
  unAuthorised,
  forbidden,
  success,
  dataParsing,
  other,
}

class ServerException implements Exception {
  late DioException dioException;
  String? message;
  ErrorType? errorType;

  ServerException({
    required this.dioException,
    this.errorType,
    this.message,
  });

  ServerException.withException({
    required this.dioException,
  });
}

class CubitException implements Exception {
  String? message;
  ErrorType? errorType;

  CubitException({this.message, this.errorType});
}

class NoInternetException implements Exception {
  String? message;

  NoInternetException({this.message});
}

class CacheException implements Exception {
  String? message;

  CacheException({
    this.message,
  });
}

class GeneralException implements Exception {
  String? message;
  String? code;

  GeneralException({
    this.message,
    this.code,
  });
}

class CustomException implements Exception {
  final String message;

  CustomException([this.message = 'An Exception has occurred']);

  @override
  String toString() => message;
}
