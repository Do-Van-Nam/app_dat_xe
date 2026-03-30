class UserInfoModel {
  static final UserInfoModel _instance = UserInfoModel._internal();

  factory UserInfoModel() => _instance;

  UserInfoModel._internal();
  static UserInfoModel get instance => _instance;

  String phoneNumber = "";
  String fullName = "";
  String username = "";
  String email = "";
  String address = "";
  int gender = -1;
  String avatar = "";
  String verified = "";
  String province = "";
  String district = "";
  String code = "";
  int userId = 0;
  String dateOfBirth = "";
  String identityNumber = "";
  String contact = "";
  String commune = "";
  String street = "";
  String nationality = "";
  String invitedCode = "";
  String fbId = "";
  String homeNo = "";
  String idType = "";
  String identityType = "";
  String issueDate = "";
  String expireDate = "";
  String visaExpireDate = "";
  String imageFront = "";
  String imageBack = "";
  String imageSelfie = "";
  String imageType = "";
  String isScan = "false";

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    final m = UserInfoModel._internal();
    m.fromJson(json);
    return m;
  }

  void fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phone_number'] ?? "";
    fullName = json['full_name'] ?? "";
    username = json['username'] ?? "";
    email = json['email'] ?? "";
    address = json['address'] ?? "";
    gender = json['gender'] ?? -1;
    avatar = json['avatar'] ?? "";
    verified = json['verified'] ?? "";
    province = json['province'] ?? "";
    district = json['district'] ?? "";
    code = json['code'] ?? "";
    userId = json['user_id'] ?? 0;
    dateOfBirth = json['date_of_birth'] ?? "";
    identityNumber = json['identity_number'] ?? "";
    contact = json['contact'] ?? "";
    commune = json['commune'] ?? "";
    street = json['street'] ?? "";
    nationality = json['nationality'] ?? "";
    invitedCode = json['invited_code'] ?? "";
    fbId = json['fb_id'] ?? "";
    homeNo = json['home_no'] ?? "";
    idType = json['id_type'] ?? "";
    identityType = json['identity_type'] ?? "";
    issueDate = json['issue_date'] ?? "";
    expireDate = json['expire_date'] ?? "";
    visaExpireDate = json['visa_expire_date'] ?? "";
    imageFront = json['image_front'] ?? "";
    imageBack = json['image_back'] ?? "";
    imageSelfie = json['image_selfie'] ?? "";
    imageType = json['image_type'] ?? "";
    isScan = json['is_scan']?.toString() ?? "false";
  }

  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'full_name': fullName,
    'username': username,
    'email': email,
    'address': address,
    'gender': gender,
    'avatar': avatar,
    'verified': verified,
    'province': province,
    'district': district,
    'code': code,
    'user_id': userId,
    'date_of_birth': dateOfBirth,
    'identity_number': identityNumber,
    'contact': contact,
    'commune': commune,
    'street': street,
    'nationality': nationality,
    'invited_code': invitedCode,
    'fb_id': fbId,
    'home_no': homeNo,
    'id_type': idType,
    'identity_type': identityType,
    'issue_date': issueDate,
    'expire_date': expireDate,
    'visa_expire_date': visaExpireDate,
    'image_front': imageFront,
    'image_back': imageBack,
    'image_selfie': imageSelfie,
    'image_type': imageType,
    'is_scan': isScan,
  };

  void clear() {
    phoneNumber = "";
    fullName = "";
    username = "";
    email = "";
    address = "";
    gender = -1;
    avatar = "";
    verified = "";
    province = "";
    district = "";
    code = "";
    userId = 0;
    dateOfBirth = "";
    identityNumber = "";
    contact = "";
    commune = "";
    street = "";
    nationality = "";
    invitedCode = "";
    fbId = "";
    homeNo = "";
    idType = "";
    identityType = "";
    issueDate = "";
    expireDate = "";
    visaExpireDate = "";
    imageFront = "";
    imageBack = "";
    imageSelfie = "";
    imageType = "";
    isScan = "false";
  }
}
