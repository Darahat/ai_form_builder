---
# 📄 Firebase Messaging Integration in Flutter (with Local Notifications)

## 📌 Overview

This guide provides a structured implementation plan for adding Firebase Cloud Messaging (FCM) to a Flutter application with support for foreground, background, and terminated notifications using the `firebase_messaging` and `flutter_local_notifications` packages.
---

## 🧰 Prerequisites

- Flutter SDK (3.x or newer)
- Firebase project ([https://console.firebase.google.com](https://console.firebase.google.com))
- Android/iOS device or emulator
- Required Flutter packages:

  ```yaml
  firebase_core: ^latest
  firebase_messaging: ^latest
  flutter_local_notifications: ^latest
  ```

---

## ⚙️ Step-by-Step Implementation

### 🔹 1. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com).
2. Create a new project or select an existing one.
3. Add your app (Android/iOS) in **Project Settings > General**.
4. Download and place `google-services.json` into `android/app`.

---

### 🔹 2. Android Configuration

#### ✅ a. `android/build.gradle`

```gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.0' // or latest
  }
}
```

#### ✅ b. `android/app/build.gradle`

Add plugins:

```gradle
plugins {
    id 'com.google.gms.google-services'
}
```

Enable Java 11 & desugaring:

```kotlin
compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
    isCoreLibraryDesugaringEnabled = true
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
```

---

### 🔹 3. Flutter Dependencies

In `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.0.0
  firebase_messaging: ^14.0.0
  flutter_local_notifications: ^17.0.0
```

---

### 🔹 4. Dart Code Setup

#### ✅ a. Firebase Initialization (`main.dart`)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const ProviderScope(child: App()));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background messages
}
```

#### ✅ b. Messaging Service (`firebase_messaging_service.dart`)

```dart
class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _requestPermission();
    await _initLocalNotifications();
    await _initMessageHandlers();
    _logToken();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    print('Permission granted: ${settings.authorizationStatus}');
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _localNotifications.initialize(settings);
  }

  Future<void> _initMessageHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              channelDescription: 'Used for important notifications.',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // Handle message tap
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      // Handle cold start
    }
  }

  void _logToken() async {
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }
}
```

---

## ❗ Common Obstacles and Solutions

| Issue                                             | Cause                                        | Solution                                                                |
| ------------------------------------------------- | -------------------------------------------- | ----------------------------------------------------------------------- |
| `MissingPluginException`                          | Plugin not initialized                       | Add `WidgetsFlutterBinding.ensureInitialized()` and run `flutter clean` |
| `App does not show notifications in foreground`   | FCM suppresses notification UI in foreground | Use `flutter_local_notifications` to display manually                   |
| `Desugaring Error`                                | Using Java 8+ APIs                           | Enable `coreLibraryDesugaring` in Gradle and add desugar library        |
| `Unsupported Gradle Project`                      | Invalid structure / KTS config               | Use `flutter create`, migrate code, then modify cleanly                 |
| Notifications don’t show in background/terminated | Android/iOS config issue                     | Test on real device, ensure proper Firebase project setup               |

---

## 🧪 Testing Tips

- Use **real Android device** for testing push notifications.
- Send test notification from **Firebase Console > Cloud Messaging**.
- Confirm that the **FCM token** is valid and visible in logs.

---

## ✅ Conclusion

By following this guide:

- FCM is properly integrated.
- Local notifications appear in foreground.
- Background and terminated notifications are handled gracefully.
- Gradle and desugaring setup is compatible with modern Flutter.

---
