import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Khởi tạo Google Sign In (gọi 1 lần khi app start)
  Future<void> initialize() async {
    print("bat sau khoi tao gg signin");
    await GoogleSignIn.instance.initialize();
    print("khoi tao xong gg signin");
  }

  /// Đăng nhập / Đăng ký bằng Google
  // Future<User?> signInWithGoogle() async {
  Future<String?> signInWithGoogle() async {
    try {
      // Đăng xuất trước để hiện popup chọn tài khoản
      await GoogleSignIn.instance.signOut();

      // Bước 1: Xác thực (Authentication)
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn.instance.authenticate();

      if (googleUser == null) return null; // Người dùng hủy

      // Lấy thông tin authentication (idToken)
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // token id
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        print("Không lấy được idToken từ Google");
        return null;
      }

      print("✅ Lấy được Google idToken thành công (độ dài: ${idToken.length})");
      // Tạo credential cho Firebase
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, // idToken vẫn có
        accessToken: null, // accessToken không còn ở đây nữa
      );

      // Đăng nhập Firebase
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
//tra ve user json
      // return userCredential.user;
// tra ve token_id
      return idToken;
    } catch (e) {
      print('Lỗi Google Sign In: $e');
      return null;
    }
  }

  /// Đăng xuất
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }
}
