import 'dart:ffi';

class BaseResponse {
  String? message;
  bool? success;
  String? code;
  dynamic data;
  int? status;
  String? errMessage;

  BaseResponse.success({
    this.data,
    this.code,
    this.message,
    this.success,
    this.status,
    this.errMessage,
  });

  BaseResponse.error(
    this.message, {
    this.data,
    this.code,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse.success(
      message: json['message'] ?? '',
      code: json['code'] ?? '',
      success: json['success'] ?? '',
      data: json['data'],
      status: json['status'],
      errMessage: json['errMessage'] ?? json['error_message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'code': code,
        'success': success,
        'data': data,
        'status': status,
        'errMessage': errMessage,
      };

  bool get isSuccess => code != null && code == "00";
  bool get isStatusSuccess => status == 200;
}
