import 'dart:convert';

import 'package:social_golf_app/core/error/exception.dart';
import 'package:social_golf_app/core/network/network_call/api_config.dart';
import 'package:social_golf_app/core/network/network_call/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data_source/auth_remote_data_source.dart';
import '../data_source/product_remote_data_source.dart';

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final NetworkClient networkClient;

  AuthRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<dynamic> login(String email, String password) async {
    final response = await networkClient.invoke(
      ApiConfig().login,
      RequestType.post,
      requestBody: jsonEncode({"email": email,"password": password}),
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      debugPrint('Exception cashIn throw ServerException');
      throw ServerException(
        dioException: DioException(
          requestOptions: response.requestOptions,
          error: response,
          type: DioExceptionType.badResponse,
        ),
      );
    }
  }


}
