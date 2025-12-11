import 'package:social_golf_app/core/network/network_call/data/model/product_list_response.dart';

class HomeProductListResponse {
  bool? error;
  List<ProductData>? data;
  String? message;

  HomeProductListResponse({this.error, this.data, this.message});

  HomeProductListResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(ProductData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}
