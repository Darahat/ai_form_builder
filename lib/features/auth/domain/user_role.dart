import 'package:hive/hive.dart';

// part 'user_role.g.dart';

@HiveType(typeId: 6)
enum UserRole {
  guest,
  authenticatedUser,
  admin,
}
