class BaseResponseV2<T> {
  final String? errorCode;
  final String? errorMessage;
  final T? result;

  BaseResponseV2({
    this.errorCode,
    this.errorMessage,
    this.result,
  });

  factory BaseResponseV2.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json)? fromJsonT,
      ) {
    return BaseResponseV2<T>(
      errorCode: json['errorCode'],
      errorMessage: json['errorMessage'],
      result: json['result'] != null && fromJsonT != null
          ? fromJsonT(json['result'])
          : null,
    );
  }

  bool get isSuccess => errorCode == "S200";
}