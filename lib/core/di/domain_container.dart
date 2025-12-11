import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/network/network_call/domain/repository/product_repository.dart';
import 'package:social_golf_app/core/network/network_call/domain/repository_impl/product_repository_impl.dart';

Future<void> initDomainDI() async {
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      networkInfo: serviceLocator(),
      remoteDataSource: serviceLocator(),
      pref: serviceLocator(),
    ),
  );
}
