import 'package:demo_app/main/data/api/api_util.dart';
import 'package:demo_app/main/data/model/user/user.dart';

class UserRepository {
  UserRepository._();
  static final UserRepository _instance = UserRepository._();
  factory UserRepository() => _instance;

  static const String _userPath = 'https://jsonplaceholder.typicode.com/users';

  /// GET danh sach user va parse thanh List<User>
  Future<List<User>> getUsers() async {
    return ApiUtil.getInstance()!.getParsed<List<User>>(
      url: _userPath,
      fromJson: (json) {
        final dynamic usersData = json['data'] ?? json['result'] ?? json;
        if (usersData is List) {
          return usersData
              .whereType<Map<String, dynamic>>()
              .map(User.fromJson)
              .toList();
        }
        return <User>[];
      },
    );
  }

  /// GET chi tiet user theo id
  Future<User> getUserDetail(String id) async {
    return ApiUtil.getInstance()!.getParsed<User>(
      url: '$_userPath/$id',
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// POST tao moi user
  Future<User> createUser(User user) async {
    return ApiUtil.getInstance()!.postParsed<User>(
      url: _userPath,
      body: user.toJson(),
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// PUT cap nhat user
  Future<User> updateUser({
    required String id,
    required User user,
  }) async {
    return ApiUtil.getInstance()!.putParsed<User>(
      url: '$_userPath/$id',
      body: user.toJson(),
      fromJson: (json) {
        final dynamic userData = json['data'] ?? json['result'] ?? json;
        if (userData is Map<String, dynamic>) {
          return User.fromJson(userData);
        }
        return User.fromJson(const {});
      },
    );
  }

  /// DELETE user, tra ve true neu status success
  Future<bool> deleteUser(String id) async {
    final response = await ApiUtil.getInstance()!.delete(
      url: '$_userPath/$id',
    );
    return response.isSuccess;
  }
}
