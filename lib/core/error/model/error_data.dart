class ErrorData {
  String? error;
  String? errorDescription;

  ErrorData({this.error, this.errorDescription});

  ErrorData.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    errorDescription = json['errorDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['errorDescription'] = errorDescription;
    return data;
  }
}