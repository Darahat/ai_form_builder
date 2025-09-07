import 'package:ai_form_builder/features/auth/domain/user_role.dart';

class UserModel {
  final String uid;
  final String? name;
  final String email;
  final UserRole? role;
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
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${map['role'] ?? 'guest'}',
        orElse: () => UserRole.guest,
      ),
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
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role'] ?? 'guest'}',
        orElse: () => UserRole.guest,
      ),
    );
  }
}
