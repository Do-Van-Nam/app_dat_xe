class DoActionServiceResponse {
  final String? refId;

  DoActionServiceResponse({this.refId});

  factory DoActionServiceResponse.fromJson(Map<String, dynamic> json) {
    return DoActionServiceResponse(
      refId: json['refId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refId': refId,
    };
  }
}