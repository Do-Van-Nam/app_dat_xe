import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<void> signInWithApple() async {
  try {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      // Nếu hỗ trợ Android/Web thì thêm:
      // webAuthenticationOptions: WebAuthenticationOptions(
      //   clientId: 'your.service.id',
      //   redirectUri: Uri.parse('https://yourdomain.com/callback'),
      // ),
    );

    print('Apple ID: ${credential.userIdentifier}');
    print('Email: ${credential.email}');
    print('Full Name: ${credential.givenName} ${credential.familyName}');
    print('Identity Token: ${credential.identityToken}');
    print('Authorization Code: ${credential.authorizationCode}');

    // Gửi credential.authorizationCode + identityToken lên Backend của bạn
    // để verify với Apple và tạo tài khoản / đăng nhập
  } catch (e) {
    print('Lỗi Sign in with Apple: $e');
    // Xử lý lỗi (người dùng hủy, v.v.)
  }
}
