class BaseResult<T> {
  final String? errorCode;
  final String? message;
  final dynamic object;
  final String? userMsg;
  final T? wsResponse;

  BaseResult({
    this.errorCode,
    this.message,
    this.object,
    this.userMsg,
    this.wsResponse,
  });

  factory BaseResult.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json)? fromJsonT,
      ) {
    return BaseResult<T>(
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
      object: json['object'],
      userMsg: json['userMsg'] as String?,
      wsResponse: fromJsonT != null && json['wsResponse'] != null
          ? fromJsonT(json['wsResponse'])
          : null,
    );
  }
}