class TopUpResponse {
  final String? topUpId;
  final String? externalId;
  final String? redirectUrl;

  TopUpResponse({
    this.topUpId,
    this.externalId,
    this.redirectUrl,
  });

  factory TopUpResponse.fromJson(Map<String, dynamic> json) {
    return TopUpResponse(
      topUpId: json['top_up_id']?.toString(),
      externalId: json['external_id']?.toString(),
      redirectUrl: json['redirect_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_up_id': topUpId,
      'external_id': externalId,
      'redirect_url': redirectUrl,
    };
  }
}
