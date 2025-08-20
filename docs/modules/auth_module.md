# Auth Module

The **Auth Module** provides functionality for:

- User Sign In
- User Sign Up
- Forgot Password
- Social Login

## Directory Structure

- **presentation/**: UI layer – contains all visual components such as pages, widgets, forms (e.g., login, sign-up).
- **domain/**: Core business logic – includes entities (e.g., UserModel), validation rules, and possibly interfaces (abstract classes) that define contracts.
- **infrastructure/**: External data source layer – implements data fetching logic such as API integrations, local storage (Hive/SharedPreferences), Firebase, etc.
- **application/**: Application logic – includes controllers (like Riverpod StateNotifiers), use cases, and acts as the glue between UI (presentation) and data sources (infrastructure).

## Usage

### Sign In

Use the `AuthController` to manage user sign-in logic.

Example:

```dart
AuthController.signIn(email, password);
```

**Github Authentication Setup process**
Certainly. Below is a complete and professional documentation for your **GitHub Authentication Setup in Flutter (Firebase)**, tailored for your project.

---

# GitHub Authentication Setup – Flutter + Firebase

This document outlines the complete process of integrating **GitHub Sign-In** in a Flutter application using **Firebase Authentication**.

---

## ✅ Prerequisites

Before beginning, ensure the following:

- A Firebase project is set up
- Firebase Auth is enabled for the project
- Flutter SDK is properly installed
- Your app is connected to Firebase using `firebase_core` and `firebase_auth`
- You have a GitHub account

---

## ⚙️ Step 1: Configure GitHub Provider in Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Navigate to your project → **Authentication** → **Sign-in method**
3. Enable **GitHub** and provide:

   - **Client ID**
   - **Client Secret**

4. **Save** the changes

---

## Step 2: Create GitHub OAuth App

1. Visit: [https://github.com/settings/developers](https://github.com/settings/developers)
2. Click **"New OAuth App"**
3. Fill out the form:

   - **Application Name**: Your app name
   - **Homepage URL**:

     ```
     https://flutter-starter-kit-3bd18.firebaseapp.com
     ```

   - **Authorization Callback URL**:

     ```
     https://flutter-starter-kit-3bd18.firebaseapp.com/__/auth/handler
     ```

4. Save the **Client ID** and **Client Secret**
5. Use these values in Firebase Authentication GitHub provider setup

---

## Step 3: Android Manifest Configuration

Open `android/app/src/main/AndroidManifest.xml` and add the following `intent-filter` inside the `<activity>` block:

```xml
<intent-filter android:label="GitHubAuth">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data
        android:scheme="https"
        android:host="flutter-starter-kit-3bd18.firebaseapp.com"
        android:path="/__/auth/handler" />
</intent-filter>
```

✅ This allows your Android app to handle GitHub OAuth redirect responses from Firebase.

---

## Step 4: Implement GitHub Auth Logic

### `auth_repository.dart`

```dart
Future<UserModel?> signInWithGithub() async {
  try {
    final githubAuthProvider = GithubAuthProvider();
    UserCredential cred;

    if (kIsWeb) {
      // For web platform
      cred = await _auth.signInWithPopup(githubAuthProvider);
    } else {
      // For Android/iOS using built-in provider (Firebase handles redirect)
      cred = await _auth.signInWithProvider(githubAuthProvider);
    }

    return UserModel(uid: cred.user!.uid, email: cred.user!.email!);
  } catch (e) {

    throw Exception('🚀 ~ Error during github sign-in: $e');
  }
}
```

### `auth_controller.dart`

```dart
Future<void> signInWithGithub() async {
  state = const AuthLoading();
  try {
    final user = await _authRepository.signInWithGithub();
    if (user != null) {
      _box.put('user', user);
      state = Authenticated(user);
    } else {
      state = const AuthError('Github Sign in failed. Please try again',AuthMethod.github);
    }
  } catch (e) {
    state = AuthError(e.toString(),AuthMethod.github);
  }
}
```

---

## ✅ Step 5: Trigger Sign-In from UI

```dart
ElevatedButton(
  onPressed: () {
    ref.read(authControllerProvider.notifier).signInWithGithub();
  },
  child: Text("Sign in with GitHub"),
)
```

---

## Step 6: Test the Flow

1. Run the app on a real Android device or emulator
2. Click “Sign in with GitHub”
3. GitHub login page opens in the browser
4. After successful login, user is redirected back to the app
5. Firebase authenticates the GitHub user and returns a `UserCredential`

---

## Summary

| Configuration        | Value                                                                         |
| -------------------- | ----------------------------------------------------------------------------- |
| Firebase GitHub Auth | Enabled with Client ID & Secret                                               |
| GitHub OAuth App     | Callback: `https://flutter-starter-kit-3bd18.firebaseapp.com/__/auth/handler` |
| AndroidManifest      | Handles OAuth redirect URI                                                    |
| Dart Code            | Uses `GithubAuthProvider` via `signInWithProvider()`                          |
| Platform             | Supports **Android**, **Web** (via `signInWithPopup`)                         |

---

## Notes

- This setup uses **Firebase’s redirect handler** and does **not require custom redirect schemes** (`myapp://...`)
- This method **does not require `flutter_web_auth_2`** or backend token exchange
- Works cleanly across Web and Android

---

# Firebase Authentication Setup and Troubleshooting

This document outlines the setup process for Firebase Authentication, focusing on common issues encountered during password reset flows and their resolutions.

## 1. Firebase Project Setup

Ensure your Firebase project is correctly set up and linked to your Flutter application.

## 2. Firebase Authentication Configuration

In the Firebase Console:

- Navigate to **Authentication** > **Sign-in method**.
- Ensure **Email/Password** provider is enabled.

## 3. Firebase App Check Configuration

App Check helps protect your backend resources from abuse. It's crucial for secure authentication flows.

### Key Checks:

- **App Registration:**
  - In Firebase Console, go to **Build** > **App Check**.
  - Ensure your Android application is properly registered.
- **SHA Fingerprints:**
  - Verify that your app's **SHA-1** and **SHA-256** fingerprints (obtained from your Android project's `signingReport` or Play Console) are correctly added to your Android app settings in the Firebase Console.
- **App Check Provider in Flutter:**

  - In your `lib/main.dart` file, ensure you are activating App Check with the appropriate provider. For Android, `AndroidProvider.playIntegrity` is recommended for production apps distributed via Google Play.

  ```dart
  import 'package:firebase_app_check/firebase_app_check.dart';
  import 'package:firebase_core/firebase_core.dart';
  // ... other imports

  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity, // Recommended for Android
      appleProvider: AppleProvider.appAttest, // Recommended for iOS
      // webProvider: ReCaptchaV3Provider('YOUR_RECAPTCHA_SITE_KEY'), // For web apps
    );
    // ... rest of your main function
  }
  ```

## 4. Troubleshooting Password Reset Issues

### Common Problem: "Empty reCAPTCHA token" or "App attestation failed" (HTTP 403)

These errors often indicate that Firebase App Check is rejecting requests due to a missing or invalid attestation token, frequently related to reCAPTCHA Enterprise.

**Symptoms:**

- `W/LocalRequestInterceptor: Error getting App Check token; using placeholder token instead.`
- `Error: com.google.firebase.FirebaseException: Error returned from API. code: 403 body: App attestation failed.`
- `Password reset request ... with empty reCAPTCHA token`

**Recovery Steps & Checks:**

1.  **Enable reCAPTCHA Enterprise API (Google Cloud Console):**

    - Go to the [Google Cloud Console](https://console.cloud.google.com/).
    - Select your project (the one linked to your Firebase project).
    - Search for "reCAPTCHA Enterprise API" and ensure it is **enabled**.

2.  **Configure reCAPTCHA Enterprise (Firebase Console):**

    - In the Firebase Console, navigate to **Build** > **App Check**.
    - Go to the **reCAPTCHA Enterprise** tab.
    - **Crucially, link your generated reCAPTCHA site key here.** If you haven't generated one, do so via the reCAPTCHA Enterprise console and then link it. This step is vital for App Check to function correctly with reCAPTCHA Enterprise.

3.  **Enable Play Integrity API (Google Cloud Console):**

    - In the [Google Cloud Console](https://console.cloud.google.com/), search for "Play Integrity API" and ensure it is **enabled** for your project.

4.  **Check Spam/Junk Folder for Emails:**
    - **Always check the spam or junk folder** of the recipient's email address. Password reset emails, especially during development or from new senders, frequently land there. This was the ultimate resolution in a recent case.

### Important Note on reCAPTCHA Integration:

While basic email/password authentication might seem simple, Firebase often leverages reCAPTCHA (especially reCAPTCHA Enterprise when App Check is enforced) for bot protection and to ensure requests originate from legitimate app instances. Even if you don't explicitly integrate reCAPTCHA into your UI, the Firebase App Check SDK, when configured with `AndroidProvider.playIntegrity` and reCAPTCHA Enterprise enabled in the Firebase Console, will handle the necessary attestation and token generation in the background. Therefore, ensuring reCAPTCHA Enterprise is correctly set up in your Firebase project is often a prerequisite for App Check to function seamlessly, even for seemingly "simple" email flows.

## 5. Testing and Verification

After making any configuration changes:

1.  Clean your Flutter project: `flutter clean`
2.  Rebuild and run your application: `flutter run`
3.  Monitor your device's Logcat for any App Check or Firebase-related messages.
