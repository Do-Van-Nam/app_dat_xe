class DetectORCResponse {
  final String? errorCode;
  final String? errorDescription;
  final String? messageCode;
  final String? idNumber;
  final String? dobEn;
  final String? provinceEn;
  final String? sexEn;
  final String? dobKh;
  final String? provinceKh;
  final String? sexKh;
  final String? name;
  final String? nationality;
  final String? expireDate;

  DetectORCResponse({
    this.errorCode,
    this.errorDescription,
    this.messageCode,
    this.idNumber,
    this.dobEn,
    this.provinceEn,
    this.sexEn,
    this.dobKh,
    this.provinceKh,
    this.sexKh,
    this.name,
    this.nationality,
    this.expireDate,
  });

  factory DetectORCResponse.fromJson(Map<String, dynamic> json) {
    return DetectORCResponse(
      errorCode: json['errorCode'] as String?,
      errorDescription: json['errorDescription'] as String?,
      messageCode: json['messageCode'] as String?,
      idNumber: json['idNumber'] as String?,
      dobEn: json['dobEn'] as String?,
      provinceEn: json['provinceEn'] as String?,
      sexEn: json['sexEn'] as String?,
      dobKh: json['dobKh'] as String?,
      provinceKh: json['provinceKh'] as String?,
      sexKh: json['sexKh'] as String?,
      name: json['name'] as String?,
      nationality: json['nationality'] as String?,
      expireDate: json['expiryDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorCode': errorCode,
      'errorDescription': errorDescription,
      'messageCode': messageCode,
      'idNumber': idNumber,
      'dobEn': dobEn,
      'provinceEn': provinceEn,
      'sexEn': sexEn,
      'dobKh': dobKh,
      'provinceKh': provinceKh,
      'sexKh': sexKh,
      'name': name,
      'nationality': nationality,
      'expiryDate': expireDate,
    };
  }
}