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
/// Listen Authstate and notify listeners to change auth state
class AuthListenable extends ChangeNotifier {
  /// An object used by providers to interact with other providers and the life-cycles of the application.
  final Ref ref;

  /// AuthListenable constructor
  AuthListenable(this.ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      notifyListeners();
    });
  }
}

/// Restrict Spalsh screen keep 3 seconds to go to login page.
/// before 3 seconds completed it wont go to login page
final initializationFutureProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 3));
});

/// Set Which route will allowed for which rules(guest,admin,authenticated user)
final Map<String, List<UserRole>> routeAllowedRoles = {
  '/home': [UserRole.authenticatedUser, UserRole.admin],
  '/settings': [UserRole.authenticatedUser, UserRole.admin],
  '/ai_form_builder_chat': [UserRole.authenticatedUser, UserRole.admin],
  '/login': [UserRole.guest],
  '/register': [UserRole.guest],
  // Add all your routes here with their allowed roles
};

/// Router provider which is using GoRouter Package provider using ref
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash', // start with the first tab
    // debugLogDiagnostics: true,
    routes: [
      /// Shell route for persistent HomeLayout with IndexedStack
      ShellRoute(
        builder: (context, state, child) {
          final String title =
              (state.extra as Map<String, dynamic>?)?['title'] ??
              state.name.toString();
          return HomeLayout(title: title, child: child);
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
