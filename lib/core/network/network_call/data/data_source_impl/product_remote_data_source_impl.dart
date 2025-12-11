import 'dart:convert';

import 'package:social_golf_app/core/error/exception.dart';
import 'package:social_golf_app/core/network/network_call/api_config.dart';
import 'package:social_golf_app/core/network/network_call/network_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../data_source/product_remote_data_source.dart';

class ProductRemoteDataSourceImpl extends ProductRemoteDataSource {
  final NetworkClient networkClient;

  ProductRemoteDataSourceImpl({required this.networkClient});

  @override
  Future<dynamic> getPopularProduct(int customerId) async {
    final response = await networkClient.invoke(
      ApiConfig().getPopularProduct,
      RequestType.post,
      requestBody: jsonEncode({"id": 'all', "customer_id": customerId}),
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

  @override
  Future<dynamic> getTrendingProduct(
    int customerId,
    String search,
    String pageNo,
  ) async {
    final response = await networkClient.invoke(
      "${ApiConfig().getTrendingProduct}?id=all&customer_id=$customerId&page=$pageNo",
      RequestType.get,
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
