import 'package:social_golf_app/core/bloc/base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';
import '../../../core/error/model/error_response_model.dart';
import '../../../core/network/network_call/data/model/home_product_list_response.dart';
import '../../../core/network/network_call/data/model/product_list_response.dart';
import '../../../core/network/network_call/domain/repository/product_repository.dart';
import '../../../core/utils/constants/enums.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;

  int _counter = 0;
  HomeProductListResponse? _hotDealsData;
  List<ProductData>? _trendingData;

  HomeBloc({required this.productRepository}) : super(const HomeState()) {
    on<GetPopularEvent>(_onGetPopular);
    on<GetTrendingEvent>(_onGetTrending);
  }

  void _checkAllApis(Emitter<HomeState> emit) {
    _counter++;
    if (_counter == 2) {
      emit(
        state.copyWith(
          status: ResponseStatus.success,
          hotDeals: _hotDealsData,
          trendingProducts: _trendingData,
        ),
      );
    }
  }

  // POPULAR
  Future<void> _onGetPopular(
    GetPopularEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ResponseStatus.inProgress));

      final response = await productRepository.getPopularProduct();

      response.fold(
        (failure) {
          ErrorModel error = handleException(failure);
          emit(
            state.copyWith(
              status: ResponseStatus.failure,
              errorMessage: error.message,
              hotDeals: null,
            ),
          );
        },
        (data) {
          if (data.error == false && data.data != null) {
            _hotDealsData = data;
            _checkAllApis(emit);
          } else {
            emit(
              state.copyWith(
                status: ResponseStatus.failure,
                errorMessage: data.message,
              ),
            );
          }
        },
      );
    } catch (e, s) {
      logger.e("Popular error: $e", s);
      emit(
        state.copyWith(
          status: ResponseStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  // TRENDING
  Future<void> _onGetTrending(
    GetTrendingEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: ResponseStatus.inProgress));

      final response = await productRepository.getTrendingProduct('', '');

      response.fold(
        (failure) {
          ErrorModel error = handleException(failure);
          emit(
            state.copyWith(
              status: ResponseStatus.failure,
              errorMessage: error.message,
              trendingProducts: null,
            ),
          );
        },
        (data) {
          final model = data;

          if (model.error == false && model.data?.data != null) {
            _trendingData = model.data!.data;
            _checkAllApis(emit);
          } else {
            emit(
              state.copyWith(
                status: ResponseStatus.failure,
                errorMessage: model.message,
              ),
            );
          }
        },
      );
    } catch (e, s) {
      logger.e("Trending error: $e", s);
      emit(
        state.copyWith(
          status: ResponseStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
