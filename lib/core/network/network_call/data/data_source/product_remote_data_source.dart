abstract class ProductRemoteDataSource {
  Future<dynamic> getPopularProduct(int customerId);
  Future<dynamic> getTrendingProduct(
    int customerId,
    String search,
    String pageNo,
  );
}
