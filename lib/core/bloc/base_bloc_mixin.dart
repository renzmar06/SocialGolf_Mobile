import 'package:social_golf_app/core/error/model/error_data.dart';
import 'package:social_golf_app/core/error/model/error_response_model.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection_container_common.dart';
import '../error/exception.dart';
import '../logger/app_logger.dart';

mixin BaseBlocMixin<State> on BlocBase<State> {
  PreferencesUtil preferences = serviceLocator<PreferencesUtil>();
  AppLogger logger = serviceLocator<AppLogger>();

  @override
  void emit(State state) {
    if (!isClosed) super.emit(state);
  }

  ErrorModel handleException(Exception exception) {
    ErrorModel errorModel = ErrorModel(message: 'An Exception has occurred');

    if (exception is ServerException) {
      return handleDioError(exception.dioException);
    } else if (exception is NoInternetException) {
      errorModel.message = "No internet connection available";
    } else if (exception is CubitException) {
      errorModel.message = exception.message;
    } else if (exception is CustomException) {
      errorModel.message = exception.message;
    } else if (exception is GeneralException) {
      errorModel.message = exception.message;
      errorModel.code = exception.code;
    }
    return errorModel;
  }

  ErrorModel handleDioError(DioException dioError) {
    ErrorModel errorModel = ErrorModel();
    debugPrint('\n\n\n\nhandleDioError ${dioError.type}');

    switch (dioError.type) {
      case DioExceptionType.cancel:
        errorModel.message = "Request was cancelled";
        break;

      case DioExceptionType.connectionTimeout:
        errorModel.message = "Connection timeout";
        break;

      case DioExceptionType.connectionError:
        errorModel.message = "Connection Error";
        break;

      case DioExceptionType.unknown:
        errorModel.message = "Failed to connect with server";
        break;

      case DioExceptionType.receiveTimeout:
        errorModel.message = "Receive timeout in connection";
        break;

      case DioExceptionType.badResponse:
        {
          ErrorResponseModel? responseModel;
          try {
            responseModel = ErrorResponseModel.fromJson(
              dioError.response?.data,
            );
          } catch (e) {
            var error = ErrorData.fromJson(dioError.response?.data);
            if (error.error != null) {
              responseModel = ErrorResponseModel(
                error: ErrorModel(
                  message: error.errorDescription ?? "",
                  code: error.error,
                ),
              );
            } else {
              responseModel = ErrorResponseModel(
                error: ErrorModel(
                  message: "An error has occurred!",
                  code: "-100",
                ),
              );
            }
          }

          errorModel = ErrorModel(
            message: responseModel.error?.message,
            code: responseModel.error?.code,
            details: responseModel.error?.details,
            validationErrors: responseModel.error?.validationErrors,
          );
        }
        break;

      case DioExceptionType.sendTimeout:
        errorModel.message = "Send timeout in connection";
        break;

      case DioExceptionType.badCertificate:
        errorModel.message = "Bad Certificate";
        break;
    }
    return errorModel;
  }
}
