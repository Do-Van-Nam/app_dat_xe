class CheckLinkResult {
  final int? errorStatus;
  final String? errorCode;
  final String? message;
  final String? directUrl;
  final dynamic linkedPaymentInfo;
  final bool? linked;
  final bool? disable;

  CheckLinkResult({
    this.errorStatus,
    this.errorCode,
    this.message,
    this.directUrl,
    this.linkedPaymentInfo,
    this.linked,
    this.disable,
  });

  factory CheckLinkResult.fromJson(Map<String, dynamic> json) {
    return CheckLinkResult(
      errorStatus: json['errorStatus'],
      errorCode: json['errorCode'],
      message: json['message'],
      directUrl: json['directUrl'],
      linkedPaymentInfo: json['linkedPaymentInfo'],
      linked: json['linked'],
      disable: json['disable'],
    );
  }

  bool get isLinkedSuccess =>
      errorStatus == 0 && errorCode == 'SUCCESS' && linked == true;

  bool get needOpenDeepLink =>
      errorStatus == 0 &&
          errorCode == 'SUCCESS' &&
          linked == false &&
          directUrl != null;
}