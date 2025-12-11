import 'package:equatable/equatable.dart';
import '../../../core/network/network_call/data/model/home_product_list_response.dart';
import '../../../core/network/network_call/data/model/product_list_response.dart';
import '../../../core/utils/constants/enums.dart';

class HomeState extends Equatable {
  final int index;
  final String type;
  final ResponseStatus status;
  final HomeProductListResponse? hotDeals;
  final List<ProductData>? trendingProducts;
  final String? errorMessage;

  const HomeState({
    this.index = -1,
    this.type = 'all',
    this.status = ResponseStatus.initial,
    this.hotDeals,
    this.trendingProducts,
    this.errorMessage,
  });

  HomeState copyWith({
    int? index,
    String? type,
    ResponseStatus? status,
    HomeProductListResponse? hotDeals,
    List<ProductData>? trendingProducts,
    String? errorMessage,
  }) {
    return HomeState(
      index: index ?? this.index,
      type: type ?? this.type,
      status: status ?? this.status,
      hotDeals: hotDeals ?? this.hotDeals,
      trendingProducts: trendingProducts ?? this.trendingProducts,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    index,
    type,
    status,
    hotDeals,
    trendingProducts,
    errorMessage,
  ];
}
