import 'package:dartz/dartz.dart';

import '../../data/model/home_product_list_response.dart';
import '../../data/model/login_response.dart';
import '../../data/model/product_list_response.dart';

abstract class AuthRepository {
  Future<Either<Exception, LoginResponse>> login(String email,String password);

}
