Troubleshooting `HiveError: Box not found` on App Startup

This document outlines the diagnosis and solution for a HiveError: Box not found exception that occurred during the initial launch of the Flutter application.

Symptom

When the app starts, it immediately crashes or displays an error screen with the following message:

1 Unhandled Exception: HiveError: Box not found. Did you forget to call Hive.openBox()?

This happened even though HiveService.init() was being called in main.dart, which correctly calls Hive.openBox().

Root Cause: A Startup Race Condition

The problem was not that Hive.openBox() wasn't being called, but when it was being called relative to when it was being used. This is a classic race condition.

The sequence of events was as follows:

1.  `main.dart` starts: The app begins to initialize.
2.  Providers are created: Riverpod starts setting up the provider graph. It creates the authControllerProvider, which in turn creates an instance of AuthController.
3.  `AuthController` tries to access Hive: Inside the AuthController, an instance variable was being initialized immediately:

1 // This line runs the moment AuthController is created
2 final Box<UserModel> \_box = Hive.box<UserModel>('authBox');

4.  `HiveService.init()` is still running: At the same time, the await HiveService.init() call in main.dart was still in progress.
5.  The Crash: The AuthController tried to access the 'authBox' before HiveService.init() had finished opening it, leading to the "Box not found" error.

The Solution: Enforcing Correct Initialization Order

We solved this by ensuring no part of the app could access a Hive box before we were 100% certain it was open.

Step 1: Remove Direct Hive Access from the Controller

We removed the problematic instance variable from AuthController. Instead of accessing the box directly, the controller now relies on our HiveService to provide the box. This
centralizes access to a single, safe point.

- Before: final Box<UserModel> \_box = Hive.box<UserModel>('authBox');
- After: All calls were changed to use HiveService.authBox, which has a built-in check to ensure Hive is initialized.

Step 2: Decouple Initial State from the Constructor

We changed the AuthController constructor so it no longer tried to read the user's login status from Hive immediately.

- Before: The constructor tried to read Hive.box('authBox').get('user').
- After: The constructor simply sets a default AuthInitial state. We added a new method, checkInitialAuthState(), to handle reading from Hive.

Step 3: Orchestrate the Startup in `main.dart`

We updated the main function to control the sequence explicitly:

1.  Initialize essential services (Logger, Firebase, etc.).
2.  await HiveService.init() and wait for it to complete.
3.  Create a ProviderContainer. This allows us to access providers before building the UI.
4.  Use the container to get the authControllerProvider and call our new checkInitialAuthState() method.
5.  Finally, run the app with runApp(), passing it the container.

This guarantees that by the time any widget tries to read the authentication state, Hive has been initialized and the correct state has been loaded.

Key Takeaway

When working with asynchronous services that need to be initialized (like databases, file storage, or network clients), always ensure the initialization is complete before any
other part of your application attempts to use the service. Using a controlled startup sequence in main.dart is a robust pattern for preventing race conditions.
