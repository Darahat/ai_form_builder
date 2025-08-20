import 'package:ai_chat/features/auth/domain/user_role.dart';
import 'package:go_router/go_router.dart';

/// A custom GoRoute that includes a list of allowed roles for route-based access control.
class AppRoute extends GoRoute {
  /// The roles that are allowed  to access this route.
  final List<UserRole> allowedRoles;

  ///AppRoute constructor
  AppRoute({
    required super.path,
    required super.builder,

    /// By default, allow all roles to access the route.
    this.allowedRoles = const [
      UserRole.guest,
      UserRole.authenticatedUser,
      UserRole.admin,
    ],
    super.routes,
    super.name,
  });
}
