import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/core/network/network_call/data/data_source/product_remote_data_source.dart';
import 'package:social_golf_app/core/network/network_call/data/data_source_impl/product_remote_data_source_impl.dart';

Future<void> initRemoteDI() async {
  serviceLocator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(networkClient: serviceLocator()),
  );
}
