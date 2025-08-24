# Authentication Tests

This document provides an overview of the tests for the authentication feature. The tests are located in `test/features/auth/application/auth_controller_test.dart`.

## Overview

The authentication tests are responsible for verifying the functionality of the `AuthController`, which manages the application's authentication state. The tests cover various authentication methods and scenarios, ensuring that the application behaves as expected.

## Mocks

The following mock classes are used to isolate the `AuthController` from its dependencies during testing:

*   **`MockAuthRepository`:** A mock of the `AuthRepository` used to simulate authentication-related operations, such as signing in, signing up, and signing out.
*   **`MockAuthBox`:** A mock of the Hive `Box<UserModel>` used to simulate local storage of user data.
*   **`MockAppLogger`:** A mock of the `AppLogger` to prevent logging during tests.

## Test Groups

The tests are organized into the following groups:

### Main

This group contains tests for the initial state of the `AuthController` and the email/password sign-in functionality.

*   **`AuthController initial state is AuthInitial`:** Verifies that the initial state of the `AuthController` is `AuthInitial`.
*   **`signIn successfully updates state to Authenticated`:** Verifies that the state is updated to `Authenticated` when the user successfully signs in with email and password.
*   **`signIn failure updates state to AuthError`:** Verifies that the state is updated to `AuthError` when the email/password sign-in fails.

### Google Sign-In

This group contains tests for the Google Sign-In functionality.

*   **`successfully updates state to Authenticated`:** Verifies that the state is updated to `Authenticated` when the user successfully signs in with Google.
*   **`failure updates state to AuthError`:** Verifies that the state is updated to `AuthError` when the Google Sign-In fails.

### Github Sign-In

This group contains tests for the Github Sign-In functionality.

*   **`successfully updates state to Authenticated`:** Verifies that the state is updated to `Authenticated` when the user successfully signs in with Github.
*   **`failure updates state to AuthError`:** Verifies that the state is updated to `AuthError` when the Github Sign-In fails.

### OTP Sign-In

This group contains tests for the OTP (One-Time Password) sign-in functionality.

*   **`SendOTP successfully updates state to OTPSent`:** Verifies that the state is updated to `OTPSent` when the OTP is successfully sent to the user's phone.
*   **`verifyOTP successfully updates state to Authenticated`:** Verifies that the state is updated to `Authenticated` when the user successfully verifies the OTP.
*   **`verifyOTP with wrong code updates state to AuthError`:** Verries that the state is updated to `AuthError` when the OTP verification fails.
