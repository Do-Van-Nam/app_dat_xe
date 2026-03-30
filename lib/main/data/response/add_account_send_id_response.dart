class AddAccountSendIdResponse {
  String? description;
  String? errorCode;

  AddAccountSendIdResponse();

  factory AddAccountSendIdResponse.fromJson(Map<String, dynamic> json) {
    final model = AddAccountSendIdResponse();
    model.description = json['description'] ?? '';
    model.errorCode = json['error_code'] ?? '';
    return model;
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'error_code': errorCode,
  };
}
