import 'dart:ffi';

class BaseResponse {
  String? message;
  bool? success;
  dynamic data;

  BaseResponse.success({
    this.data,
    this.message,
    this.success,
  });

  BaseResponse.error(
    this.message, {
    this.data,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse.success(
      message: json['message'] ?? '',
      success: json['success'] ?? '',
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': data,
      };

  bool get isSuccess => success == true;
}
