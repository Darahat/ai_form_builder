# Firebase Debugging and Notification Guide

This guide provides an overview of the notification functionality in the app, as well as some recommendations for improvement.

## Notification Functionality

The notification functionality is implemented using Firebase Cloud Messaging (FCM). The core logic is located in the `lib/core/services/firebase_messaging_service.dart` file.

### Initialization

The app initializes Firebase and the notification service in the `main.dart` and `lib/core/services/initialization_service.dart` files. The initialization process is well-structured and includes the following steps:

*   Initializing the Flutter framework.
*   Initializing the logger.
*   Initializing Firebase.
*   Activating Firebase App Check.
*   Initializing Hive for local storage.
*   Initializing the `FlutterLocalNotificationsPlugin`.
*   Registering a background message handler.

### Token Management

The app correctly gets the FCM token and saves it to the user's document in Firestore when a user signs in. The token is stored in an array called `fcmTokens`.

The app also sets up a listener for token refreshes, so that the token is updated in Firestore whenever it changes.

**Recommendation:** The app does not currently remove the FCM token from the user's document when they sign out. This should be fixed to prevent sending notifications to logged-out devices. You can do this by calling the `removeTokenFromDatabase()` method from the `FirebaseMessagingService` in the `signOut()` method of the `AuthRepository`.

### Message Handling

The app sets up handlers for foreground, background, and terminated states.

*   **Foreground Messages:** The handling of foreground messages is currently commented out. This should be enabled so that users can see notifications when they are using the app. You can do this by uncommenting the following line in the `_setupMessageHandlers()` method of the `FirebaseMessagingService`:

    ```dart
    // FirebaseMessaging.onMessage.listen(_showLocalNotification);
    ```

*   **Background Messages:** The background message handler is registered, but the logic for showing a notification is commented out. This should be enabled so that users can receive notifications when the app is in the background or terminated. You can do this by uncommenting the code in the `firebaseMessagingBackgroundHandler()` function.

*   **Notification Tapping:** The app correctly handles tapping on a notification and navigates the user to the appropriate screen.

## How to Test Notifications

You can test notifications by sending a test message from the Firebase console.

1.  Go to the [Firebase console](https://console.firebase.google.com/).
2.  Select your project.
3.  In the left-hand menu, go to **Engage** > **Messaging**.
4.  Click **New campaign** and select **Notifications**.
5.  Enter a title and body for your notification.
6.  In the **Device preview** section, you will see a preview of your notification.
7.  Click **Send test message**.
8.  Enter the FCM token for the device you want to send the notification to. You can get the FCM token by printing it to the console when the app starts.
9.  Click **Test**.

## Firebase Deployment

You can deploy your Firebase project using the Firebase CLI.

### Deploying the Entire Project

To deploy all parts of your Firebase project (including functions, Firestore rules, and hosting), run the following command:

```bash
firebase deploy
```

### Deploying Specific Parts

You can also deploy specific parts of your project using the `--only` flag.

*   **Deploying only functions:**

    ```bash
    firebase deploy --only functions
    ```

*   **Deploying only Firestore rules:**

    ```bash
    firebase deploy --only firestore:rules
    ```

*   **Deploying only hosting:**

    ```bash
    firebase deploy --only hosting
    ```

## Managing Cloud Functions

You can manage your Cloud Functions using the Firebase CLI.

### Deleting a Cloud Function

To delete a Cloud Function, use the `functions:delete` command, followed by the name of the function.

```bash
firebase functions:delete sendChatNotification
```

You will be prompted to confirm that you want to delete the function.

### Getting Information About Deployed Functions

To see a list of all your deployed functions, run the following command:

```bash
firebase functions:list
```

To see the details of a specific function, use the `functions:log` command with the `--only` flag.

```bash
firebase functions:log --only sendChatNotification
```

## Getting Firebase Project Info

You can get information about your Firebase project using the Firebase CLI.

### Listing Your Projects

To see a list of all your Firebase projects, run the following command:

```bash
firebase projects:list
```

### Seeing the Current Project

The `firebase projects:list` command will also show you which project is currently active.

To switch to a different project, use the `firebase use` command, followed by the project ID.

```bash
firebase use <your-firebase-project-id>
```