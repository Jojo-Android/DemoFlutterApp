import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    int? id,
    required String name,
    required String email,
    required String password,
    String? imagePath,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// 🔧 Extension สำหรับ SQLite DB
extension UserModelDBExtension on UserModel {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'name': name,
      'imagePath': imagePath,
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      email: map['email'] as String,
      password: map['password'] as String,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String?,
    );
  }
}
