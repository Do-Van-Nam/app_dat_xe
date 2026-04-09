import 'package:demo_app/main/base/base_response.dart';
import 'package:demo_app/main/data/model/sign_in_model.dart';

class SignInResponse extends BaseResponse {
  SignInModel? signInData;

  SignInResponse({this.signInData, super.message, super.data})
      : super.success();

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      message: json['message'],
      data: json['data'],
      signInData:
          json['data'] != null ? SignInModel.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': signInData?.toJson(),
    };
  }
}
