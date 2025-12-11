import 'package:dartz/dartz.dart';

import '../../data/model/home_product_list_response.dart';
import '../../data/model/product_list_response.dart';

abstract class ProductRepository {
  Future<Either<Exception, HomeProductListResponse>> getPopularProduct();
  Future<Either<Exception, ProductListResponse>> getTrendingProduct(
    String search,
    String pageNo,
  );
}
