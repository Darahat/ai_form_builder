import 'package:hive/hive.dart';

part 'user_role.g.dart';

@HiveType(typeId: 6)
class UserRole {
  @HiveField(0)
  final String roleName;

  // Public unnamed constructor for Hive deserialization
  const UserRole(this.roleName);

  static const UserRole guest = UserRole('guest');
  static const UserRole authenticatedUser = UserRole('authenticatedUser');
  static const UserRole admin = UserRole('admin');

  @override
  String toString() => 'UserRole.$roleName';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRole &&
          runtimeType == other.runtimeType &&
          roleName == other.roleName);

  @override
  int get hashCode => roleName.hashCode;
}