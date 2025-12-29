import 'package:social_golf_app/core/error/exception.dart';
import 'package:social_golf_app/core/network/network_call/network_info.dart';
import 'package:social_golf_app/core/shared_pref/preferences_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../shared_pref/constants.dart';
import '../../data/data_source/auth_remote_data_source.dart';
import '../../data/data_source/product_remote_data_source.dart';
import '../../data/model/home_product_list_response.dart';
import '../../data/model/login_response.dart';
import '../../data/model/product_list_response.dart';
import '../repository/auth_repository.dart';
import '../repository/product_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteDataSource remoteDataSource;
  final PreferencesUtil pref;

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.pref,
  });

  @override
  Future<Either<Exception, LoginResponse>> login(String email,String password) async {
    if (await networkInfo.checkIsConnected()) {
      try {
        final response = await remoteDataSource.login(email,password);
        if (response['error'] == true) {
          return Left(
            GeneralException(message: response['message'], code: '1001'),
          );
        }
        LoginResponse responseModel =
        LoginResponse.fromJson(response);
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
