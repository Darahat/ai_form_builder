run `firebase deploy --only firestore:rules --project ****(Firebase APP Id)`
this is for deploy firebase rules to firestore
here is how to get Sha-1 and SHA-256 for firebase setup . run this command below
`keytool -list -v -keystore "C:\Users\***\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android`

after that download google-service.json and insert it to android folder

cd functions
npm install
firebase deploy

fix lint run this command
npx eslint . --fix
run firebase use _Firebase project ID_

# Firebase Setup and Deployment Guide

This guide provides a comprehensive walkthrough of setting up and deploying a Flutter application with Firebase, including Firestore rules, Cloud Functions, and Android app configuration.

## 1. Firebase Project Setup

Before you can use Firebase with your application, you need to create a Firebase project and add your Android app to it.

1.  **Create a Firebase Project:**

    - Go to the [Firebase console](https://console.firebase.google.com/).
    - Click "Add project" and follow the on-screen instructions to create a new project.

2.  **Add an Android App to Your Project:**
    - In the Firebase console, go to your project's settings.
    - In the "Your apps" card, select the Android icon to launch the setup workflow.
    - Enter your app's package name. You can find this in your `android/app/build.gradle.kts` file (look for the `applicationId` value).

## 2. Android App Configuration

To connect your Flutter app to Firebase, you need to provide some information about your Android app, including its SHA-1 and SHA-256 keys.

1.  **Get Your SHA-1 and SHA-256 Keys:**

    - Open a terminal and run the following command:
      ```bash
      keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
      ```
    - This command will print the SHA-1 and SHA-256 fingerprints for your debug key.

2.  **Add Your SHA Keys to Firebase:**

    - In the Firebase console, go to your project's settings.
    - In the "Your apps" card, select your Android app.
    - Click "Add fingerprint" and enter the SHA-1 and SHA-256 keys that you just generated.

3.  **Download the `google-services.json` File:**
    - In the Firebase console, download the `google-services.json` file for your Android app.
    - Place this file in the `android/app` directory of your Flutter project.

## 3. Firestore Rules Deployment

Firestore rules control access to your Firestore database.

1.  **Write Your Rules:**

    - The rules are defined in the `firestore.rules` file in the root of your project.

2.  **Deploy Your Rules:**
    - To deploy your Firestore rules, run the following command:
      ```bash
      firebase deploy --only firestore:rules --project <your-firebase-project-id>
      ```
    - Replace `<your-firebase-project-id>` with your actual Firebase project ID.

## 4. Cloud Functions Deployment

Cloud Functions allow you to run backend code in response to events triggered by Firebase features and HTTPS requests.

1.  **Set Up Your Functions Directory:**

    - The code for your Cloud Functions is located in the `functions` directory.

2.  **Install Dependencies:**

    - Navigate to the `functions` directory and install the necessary dependencies:
      ```bash
      cd functions
      npm install
      ```

3.  **Fix Linting Errors:**

    - Before deploying, it's a good practice to fix any linting errors in your code:
      ```bash
      npx eslint . --fix
      ```

4.  **Deploy Your Functions:**
    - To deploy your Cloud Functions, run the following command:
      ```bash
      firebase deploy --only functions
      ```

## 5. Switching Between Firebase Projects

If you have multiple Firebase projects, you can easily switch between them using the Firebase CLI.

1.  **List Your Projects:**

    - To see a list of all your Firebase projects, run the following command:
      ```bash
      firebase projects:list
      ```

2.  **Switch to a Different Project:**
    - To switch to a different project, use the `firebase use` command, followed by the project ID:
      ```bash
      firebase use <your-firebase-project-id>
      ```
    - Replace `<your-firebase-project-id>` with the ID of the project you want to use.
