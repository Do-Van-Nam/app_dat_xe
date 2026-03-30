class ButtonCallback {
  final String buttonName;
  final String callbackData;
  final String type;
  final String? linkAddress;
  final String? iconNameAddress;
  final String isCallLinkIfLogin;

  ButtonCallback({
    required this.buttonName,
    required this.callbackData,
    required this.type,
    this.linkAddress,
    this.iconNameAddress,
    required this.isCallLinkIfLogin,
  });

  factory ButtonCallback.fromJson(Map<String, dynamic> json) {
    return ButtonCallback(
      buttonName: json['buttonName'] as String? ?? '',
      callbackData: json['callbackData'] as String? ?? '',
      type: json['type'] as String? ?? '',
      linkAddress: json['linkAddress'] as String?,
      iconNameAddress: json['iconNameAddress'] as String?,
      isCallLinkIfLogin: json['isCallLinkIfLogin'] as String? ?? 'false',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buttonName': buttonName,
      'callbackData': callbackData,
      'type': type,
      'linkAddress': linkAddress,
      'iconNameAddress': iconNameAddress,
      'isCallLinkIfLogin': isCallLinkIfLogin,
    };
  }
}
