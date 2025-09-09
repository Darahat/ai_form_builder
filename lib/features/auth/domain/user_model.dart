import 'package:ai_form_builder/features/auth/domain/user_role.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
class UserModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String email;
  @HiveField(3)
  final UserRole? role;
  @HiveField(4)
  final String? photoURL;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoURL,
    UserRole? role,
  }) : role = role ?? UserRole.guest;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoURL: map['photoURL'],
      role: _parseUserRole(map['role'] as String?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
      'photoURL': photoURL,
    };
  }

  factory UserModel.fromFirestore(doc) {
    final data = doc.data();
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['displayName'] ?? 'No Name',
      photoURL: data['photoURL'],
      role: _parseUserRole(data['role'] as String?),
    );
  }

  static UserRole _parseUserRole(String? roleString) {
    switch (roleString) {
      case 'authenticatedUser':
        return UserRole.authenticatedUser;
      case 'admin':
        return UserRole.admin;
      case 'guest':
      default:
        return UserRole.guest;
    }
  }
}
