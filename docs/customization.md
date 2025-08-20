Customization Guide

🏷️ Change App Name

Update the pubspec.yaml file:

name: your_app_name

Android: android/app/src/main/AndroidManifest.xml

iOS: ios/Runner/Info.plist

🖼️ Change App Icons & Splash

Use flutter_launcher_icons

Use flutter_native_splash

flutter pub run flutter_launcher_icons:main
flutter pub run flutter_native_splash:create

🎨 Change Theme & Colors

Go to shared/theme/app_theme.dart

Update color palette, font sizes, padding, radius, etc.

🌐 Change Language / Localization

Modify supported locales in settings_module

Add JSON or ARB files for each language

Use intl or easy_localization package

🧪 Branding Assets

Replace logos in assets/images

Reference in UI through Image.asset('assets/images/logo.png')

📁 Change Package Name

Android: Update in android/app/build.gradle

iOS: Update in ios/Runner.xcodeproj

Or use CLI: flutter pub run change_app_package_name:main com.example.app

🧭 Best Practices

Use Riverpod for scalable, testable state management

Keep features decoupled and reusable

Reuse shared widgets across features

Use core/errors for global error handling

Create use_cases and repositories to separate logic
