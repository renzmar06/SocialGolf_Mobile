import 'package:social_golf_app/core/di/injection_container_common.dart';
import 'package:social_golf_app/src/home/bloc/home_bloc.dart';

import '../../src/auth/signIn/bloc/sign_in_bloc.dart';
import '../../src/auth/signUp/bloc/sign_up_bloc.dart';

Future<void> initPresentationDI() async {
  // serviceLocator.registerFactory<ProductCubit>(
  //   () => ProductCubit(repository: serviceLocator()),
  // );
  serviceLocator.registerFactory<HomeBloc>(
    () => HomeBloc(productRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<SignUpBloc>(
    () => SignUpBloc(authRepository: serviceLocator()),
  );
  serviceLocator.registerFactory<SignInBloc>(
    () => SignInBloc(authRepository: serviceLocator()),
  );
}
