import 'package:ai_form_builder/app/router.dart';
import 'package:ai_form_builder/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Manages Firebase Cloud Messaging, including token handling and notification display.
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoRouter _goRouter;

  /// Singleton instance for local notifications plugin.
  late final FlutterLocalNotificationsPlugin _localNotificationsPlugin;

  /// FirebaseMessagingService constructor which passing goRouter .
  /// When user will click on notification it will take him to exact chat destination page
  FirebaseMessagingService(this._goRouter);

  /// Initializes the messaging service, requests permissions, and sets up handlers.
  Future<void> initialize() async {
    // Initialize local notifications
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await _initializeLocalNotifications();

    // Request notification permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Set up message handlers
    _setupMessageHandlers();

    // Handle initial token and token refreshes
    await _handleToken();
  }

  /// Sets up handlers for foreground, background, and terminated states.
  void _setupMessageHandlers() {
    // Foreground messages
    // FirebaseMessaging.onMessage.listen(_showLocalNotification);

    // Tapped notification from background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Tapped notification from terminated state
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  /// Gets the initial FCM token and sets up a listener for token refreshes.
  Future<void> _handleToken() async {
    final token = await _firebaseMessaging.getToken();
    await _saveTokenToDatabase(token);
    _firebaseMessaging.onTokenRefresh.listen(_saveTokenToDatabase);
  }

  /// Saves the FCM token to an array in the user's Firestore document.
  Future<void> _saveTokenToDatabase(String? token) async {
    if (token == null) return;
    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      await userDocRef.set({
        'fcmTokens': FieldValue.arrayUnion([token]),
      }, SetOptions(merge: true));
    }
  }

  /// Removes the FCM token from the user's document on sign-out.
  Future<void> removeTokenFromDatabase() async {
    final token = await _firebaseMessaging.getToken();
    if (token == null) return;
    final user = _auth.currentUser;
    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      await userDocRef.update({
        'fcmTokens': FieldValue.arrayRemove([token]),
      });
    }
  }

  /// Navigates to the appropriate screen when a notification is tapped.
  void _handleNotificationTap(RemoteMessage message) {
    final type = message.data['type'];
    if (type == 'chat') {
      final chatId = message.data['chatId'];
      if (chatId != null) {
        _goRouter.go('/uToUChat/$chatId');
      }
    }
  }

  /// Initializes the local notifications plugin.
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);
    await _localNotificationsPlugin.initialize(settings);
  }

  /// Displays a local notification for foreground messages.
  // void _showLocalNotification(RemoteMessage message) {
  //   final notification = message.notification;
  //   if (notification != null) {
  //     _localNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           'high_importance_channel',
  //           'High Importance Notifications',
  //           channelDescription: 'Used for important notifications.',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           icon: '@mipmap/ic_launcher',
  //         ),
  //       ),
  //     );
  //   }
  // }
}

/// Background message handler. Must be a top-level function.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // final localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  // const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  // const settings = InitializationSettings(android: androidSettings);
  // await localNotificationsPlugin.initialize(settings);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //  final notification = message.notification;
  // if (notification != null) {
  //   localNotificationsPlugin.show(
  //     notification.hashCode,
  //     notification.title,
  //     notification.body,
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'high_importance_channel',
  //         'High Importance Notifications',
  //         channelDescription: 'Used for important notifications.',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //         icon: '@mipmap/ic_launcher',
  //       ),
  //     ),
  //   );
  // }
}

/// Riverpod provider for FirebaseMessagingService.
final firebaseMessagingServiceProvider = Provider<FirebaseMessagingService>((
  ref,
) {
  final goRouter = ref.watch(routerProvider);
  return FirebaseMessagingService(goRouter);
});
