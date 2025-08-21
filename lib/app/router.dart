// import 'package:ai_form_builder/app/app_route.dart';
// import 'package:ai_form_builder/core/utils/logger.dart';
import 'package:ai_form_builder/features/ai_chat/presentation/pages/ai_chat_view.dart';
import 'package:ai_form_builder/features/ai_form_builder/presentation/pages/ai_form_builder_chat_view.dart';
import 'package:ai_form_builder/features/app_settings/presentation/pages/setting_page.dart';
import 'package:ai_form_builder/features/auth/application/auth_state.dart';
import 'package:ai_form_builder/features/auth/domain/user_role.dart';
import 'package:ai_form_builder/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ai_form_builder/features/auth/presentation/pages/login_page.dart';
import 'package:ai_form_builder/features/auth/presentation/pages/otp_page.dart';
import 'package:ai_form_builder/features/auth/presentation/pages/phone_number_page.dart';
import 'package:ai_form_builder/features/auth/presentation/pages/signup_page.dart';
import 'package:ai_form_builder/features/auth/provider/auth_providers.dart';
import 'package:ai_form_builder/features/home/presentation/layout/home_layout.dart';
import 'package:ai_form_builder/features/home/presentation/pages/home_page.dart';
import 'package:ai_form_builder/features/utou_chat/presentation/pages/user_list_page.dart';
import 'package:ai_form_builder/features/utou_chat/presentation/pages/utou_chat_view.dart';
import 'package:ai_form_builder/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// A helper class to bridge Riverpod's StateNotifier to a ChangeNotifier.
/// This allows GoRouter's `refreshListenable` to react to changes in the
/// authentication state.
final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AuthListenable extends ChangeNotifier {
  final Ref ref;

  AuthListenable(this.ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }
}

final initializationFutureProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
});
final Map<String, List<UserRole>> routeAllowedRoles = {
  '/home': [UserRole.authenticatedUser, UserRole.admin],
  '/settings': [UserRole.authenticatedUser, UserRole.admin],
  '/ai_form_builder_chat': [UserRole.authenticatedUser, UserRole.admin],
  '/login': [UserRole.guest],
  '/register': [UserRole.guest],
  // Add all your routes here with their allowed roles
};
final routerProvider = Provider<GoRouter>((ref) {
  final authListenable = AuthListenable(ref);

  // final homeController = ref.read(homeControllerProvider.notifier);
  return GoRouter(
    initialLocation: '/splash', // start with the first tab
    // debugLogDiagnostics: true,
    routes: [
      /// Shell route for persistent HomeLayout with IndexedStack
      ShellRoute(
        builder: (context, state, child) {
          return HomeLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/aiChat',
            name: 'aiChat',
            builder: (context, state) => const AiChatView(),
          ),
          GoRoute(
            path: '/uToUUserListPage',
            name: 'uToUUserListPage',
            builder: (context, state) => const UserListPage(),
          ),
          GoRoute(
            path: '/uToUChat/:id',
            name: 'uToUChat',
            builder: (context, state) {
              final receiverId = state.pathParameters['id']!;
              final receiverName =
                  state.uri.queryParameters['name'] ?? 'No Name';
              return UToUChatView(
                receiverId: receiverId,
                receiverName: receiverName,
              );
            },
          ),
        ],
      ),
      // Top-level route for settings
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/ai_form_builder_chat',
        name: 'ai_form_builder_chat',
        builder: (context, state) => const AiFormBuilderChatView(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const SignUpPage(),
      ),
      GoRoute(
        path: '/phone-number',
        name: 'phone-number',
        builder: (context, state) => const PhoneNumberPage(),
      ),
      GoRoute(
        path: '/otp',
        name: 'otp',
        builder: (context, state) => const OTPPage(),
      ),
      GoRoute(
        path: '/forget_password',
        name: 'forget_password',
        builder: (context, state) => const ForgetPassword(),
      ),

      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreenWidget(),
      ),
    ],
    redirect: (context, state) {
      final isInitialized = ref.watch(initializationFutureProvider).hasValue;
      if (!isInitialized) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }

      final authState = ref.read(authControllerProvider);
      final isAuthenticated = authState is Authenticated;

      final isAuthRoute = [
        '/login',
        '/register',
        '/phone-number',
        '/otp',
        '/forget_password',
      ].contains(state.matchedLocation);
      if (state.matchedLocation == '/splash') {
        return isAuthenticated ? '/home' : '/login';
      }

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }

      return null;
    },
  );
});

  /// Define your routes using the custom AppRoute
  // final routes = [
  //   AppRoute(
  //     path: '/splash',
  //     name: 'splash',
  //     // Only non-authenticated users (guests) can see the login page.
  //     allowedRoles: [
  //       UserRole.guest,
  //       UserRole.authenticatedUser,
  //       UserRole.admin,
  //     ],
  //     builder: (context, state) => const SplashScreenWidget(),
  //   ),
  //   AppRoute(
  //     path: '/login',
  //     name: 'login',
  //     // Only non-authenticated users (guests) can see the login page.
  //     allowedRoles: [UserRole.guest],
  //     builder: (context, state) => const LoginPage(),
  //   ),
  //   AppRoute(
  //     path: '/register',
  //     name: 'register',
  //     // Only non-authenticated users (guests) can see the login page.
  //     allowedRoles: [UserRole.guest],
  //     builder: (context, state) => const SignUpPage(),
  //   ),
  //   AppRoute(
  //     path: '/phone-number',
  //     name: 'phone-number',
  //     // Only non-authenticated users (guests) can see the login page.
  //     allowedRoles: [UserRole.guest],
  //     builder: (context, state) => const PhoneNumberPage(),
  //   ),
  //   AppRoute(
  //     path: '/otp',
  //     name: 'otp',
  //     // Only authenticated users  can see the Home page.
  //     allowedRoles: [UserRole.guest],
  //     builder: (context, state) => const OTPPage(),
  //   ),
  //   AppRoute(
  //     path: '/forget_password',
  //     name: 'forget_password',
  //     // Only authenticated users  can see the Home page.
  //     allowedRoles: [UserRole.guest],
  //     builder: (context, state) => const ForgetPassword(),
  //   ),
  //   AppRoute(
  //     path: '/home',
  //     name: 'home',
  //     allowedRoles: [UserRole.authenticatedUser, UserRole.admin],
  //     builder: (context, state) => HomeLayout(child: const HomePage()),
  //   ),
  //   AppRoute(
  //     path: '/aiChat',
  //     name: 'aiChat',
  //     allowedRoles: [UserRole.authenticatedUser, UserRole.admin],
  //     builder: (context, state) => HomeLayout(child: const AiChatView()),
  //   ),
  //   AppRoute(
  //     path: '/uToUChat',
  //     name: 'uToUChat',
  //     // Only authenticated users  can see the Home page.
  //     allowedRoles: [UserRole.authenticatedUser, UserRole.admin],
  //     builder: (context, state) => HomeLayout(child: const UserListPage()),
  //   ),
  //   AppRoute(
  //     path: '/settingsPage',
  //     name: 'settingsPage',
  //     // Only authenticated users  can see the Home page.
  //     allowedRoles: [UserRole.authenticatedUser, UserRole.admin],
  //     builder: (context, state) => const SettingsPage(),
  //   ),
   
  // ];
//   return GoRouter(
//     initialLocation: '/splash',
//     routes: routes,
//     refreshListenable: authListenable,
//     redirect: (context, state) {
//       // We watch the initialization provider to ensure the splash screen is shown for at least 3 seconds.
//       final isInitialized = ref.watch(initializationFutureProvider).hasValue;

//       // If the app is not initialized yet, stay on the splash screen.
//       if (!isInitialized) {
//         return state.matchedLocation == '/splash' ? null : '/splash';
//       }

//       /// Determine the user's role and authentication status
//       final authState = ref.read(authControllerProvider);
//       final (userRole, isAuthenticated) = switch (authState) {
//         Authenticated(user: final user) => (user.role, true),
//         _ => (UserRole.guest, false),
//       };

//       /// After initialization redirect from splash screen
//       if (state.matchedLocation == '/splash') {
//         return isAuthenticated ? '/home' : '/login';
//       }

//       /// Get the route definition for the current location
//       /// We need to handle the case where the route might not be in our list
//       final route = routes.firstWhere(
//         (r) => r.path == state.matchedLocation,
//         orElse:
//             () => AppRoute(
//               path: '/not-found',
//               builder: (context, state) => const Scaffold(),
//               allowedRoles: [],

//               /// No Roles Allowed , will trigger a redirect
//             ),
//       );

//       /// Check if the user's role is allowed for this route
//       if (route.allowedRoles.contains(userRole)) {
//         return null;
//       }

//       /// If access is denied, redirect them.
//       return isAuthenticated ? '/home' : '/login';
//     },
//   );
// });
