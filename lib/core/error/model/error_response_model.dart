import 'package:equatable/equatable.dart';

class ErrorResponseModel {
  ErrorModel? error;

  ErrorResponseModel({this.error});

  ErrorResponseModel.fromJson(Map<String, dynamic> json) {
    error = json['error'] != null ? ErrorModel.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (error != null) {
      data['error'] = error!.toJson();
    }
    return data;
  }
}

class ErrorModel extends Equatable {
  String? code;
  String? message;
  String? details;
  List<ValidationErrors>? validationErrors;

  ErrorModel({this.code, this.message, this.details, this.validationErrors});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    details = json['details'];
    if (json['validationErrors'] != null && json['validationErrors'] is List) {
      validationErrors = <ValidationErrors>[];
      json['validationErrors'].forEach((v) {
        validationErrors!.add(ValidationErrors.fromJson(v));
      });
    } else {
      validationErrors = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    data['details'] = details;
    if (validationErrors != null) {
      data['validationErrors'] =
          validationErrors!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  List<Object?> get props => [
    code,
    message,
    details,
    validationErrors,
  ];
}

class ValidationErrors {
  String? message;
  List<String>? members;

  ValidationErrors({this.message, this.members});

  ValidationErrors.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    members = json['members'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['members'] = members;
    return data;
  }
}
