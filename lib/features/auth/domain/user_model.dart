import 'package:ai_form_builder/features/auth/domain/user_role.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 2)
/// its User model for authentication
class UserModel {
  /// first field for the hive/table is uid
  @HiveField(0)
  final String uid;

  /// second non required field
  @HiveField(1)
  final String? name;

  /// third required field for login
  @HiveField(2)
  final String email;

  /// Field for what is role of user
  @HiveField(3)
  final UserRole? role;

  /// Field for user's photo URL
  @HiveField(4)
  final String? photoURL;

  /// its construct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.photoURL,
    UserRole? role,
  }) : role = role ?? UserRole.guest;

  /// its construct of UserModel class . its for call UserModel to other dart file.  this.name is not required
  //  │        UserModel({required this.uid, required this.email, this.name, UserRole? role})
  //  │          : role = role ?? UserRole.guest;

  factory UserModel.fromFirestore(doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['displayName'] ?? 'No Name',
      photoURL: data['photoURL'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.' + (data['role'] ?? 'guest'),
        orElse: () => UserRole.guest,
      ),
    );
  }
}
