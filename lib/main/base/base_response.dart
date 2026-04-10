class BaseResponse {
  String? message;
  bool? success;
  dynamic data;
  dynamic errors;

  BaseResponse.success({
    this.data,
    this.message,
    this.success,
    this.errors,
  });

  BaseResponse.error(
    this.message, {
    this.data,
    this.errors,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse.success(
      message: json['message'] ?? '',
      success: json['success'] ?? '',
      data: json['data'],
      errors: json['errors'],
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'success': success,
        'data': data,
        'errors': errors,
      };

  bool get isSuccess => success == true;
}
