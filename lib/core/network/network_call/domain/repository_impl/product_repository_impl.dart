import 'package:social_golf_app/core/error/exception.dart';
import 'package:social_golf_app/core/network/network_call/network_info.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../shared_pref/constants.dart';
import '../../data/data_source/product_remote_data_source.dart';
import '../../data/model/home_product_list_response.dart';
import '../../data/model/product_list_response.dart';
import '../repository/product_repository.dart';

class ProductRepositoryImpl extends ProductRepository {
  final NetworkInfo networkInfo;
  final ProductRemoteDataSource remoteDataSource;
  final PreferencesUtil pref;

  ProductRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.pref,
  });

  @override
  Future<Either<Exception, HomeProductListResponse>> getPopularProduct() async {
    if (await networkInfo.checkIsConnected()) {
      try {
        int customerId = pref.getPreferencesIntData(Constants.preCustomerIdKey);
        final response = await remoteDataSource.getPopularProduct(customerId);
        if (response['error'] == true) {
          return Left(
            GeneralException(message: response['message'], code: '1001'),
          );
        }
        HomeProductListResponse responseModel =
            HomeProductListResponse.fromJson(response);
        return Right(responseModel);
      } on ServerException catch (exception) {
        return Left(
          ServerException(
            dioException: DioException(
              error: exception.dioException,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      }
    } else {
      return Left(NoInternetException(message: 'No Internet Connection'));
    }
  }

  @override
  Future<Either<Exception, ProductListResponse>> getTrendingProduct(
    String search,
    String pageNo,
  ) async {
    if (await networkInfo.checkIsConnected()) {
      try {
        int customerId = pref.getPreferencesIntData(Constants.preCustomerIdKey);
        final response = await remoteDataSource.getTrendingProduct(
          customerId,
          search,
          pageNo,
        );
        if (response['error'] == true) {
          return Left(
            GeneralException(message: response['message'], code: '1001'),
          );
        }
        ProductListResponse responseModel = ProductListResponse.fromJson(
          response,
        );
        return Right(responseModel);
      } on ServerException catch (exception) {
        return Left(
          ServerException(
            dioException: DioException(
              error: exception.dioException,
              requestOptions: RequestOptions(),
            ),
          ),
        );
      }
    } else {
      return Left(NoInternetException(message: 'No Internet Connection'));
    }
  }
}
