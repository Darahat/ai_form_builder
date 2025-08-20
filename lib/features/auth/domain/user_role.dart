import 'package:hive/hive.dart';

part 'user_role.g.dart';

/// UserRole enums
@HiveType(typeId: 6) // Choose a unique typeId, e.g., 3 (UserModel is 2)
enum UserRole {
  /// A user who is not logged in
  @HiveField(0)
  guest,

  /// A standard, logged-in user.
  @HiveField(1)
  authenticatedUser,

  /// A user with administrative privileges
  @HiveField(2)
  admin,
}
