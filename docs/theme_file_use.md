/// ----------------------------------------------------------------------------
///
/// HOW TO USE THE THEME
///
/// ----------------------------------------------------------------------------
///
/// This file defines the light and dark themes for the application.
/// To use these themes, you need to set them in your `MaterialApp` widget.
///
/// ## 1. Applying the Theme
///
/// In your `main.dart` or wherever your `MaterialApp` is defined, import this file
/// and set the `theme` and `darkTheme` properties.
///
/// `dart
/// import 'package:ai_chat/app/theme/app_theme.dart';
///
/// MaterialApp(
///   title: 'My App',
///   theme: lightTheme,
///   darkTheme: darkTheme,
///   themeMode: ThemeMode.system, // Or ThemeMode.light, ThemeMode.dark
///   home: MyHomePage(),
/// );
/// `
///
/// ## 2. Using Text Styles
///
/// The `textTheme` defines various text styles that you can use throughout your app.
/// To apply a text style, use `Theme.of(context).textTheme`.
///
/// `dart
/// Text(
///   'This is a display large text',
///   style: Theme.of(context).textTheme.displayLarge,
/// );
///
/// Text(
///   'This is a body medium text',
///   style: Theme.of(context).textTheme.bodyMedium,
/// );
/// `
///
/// ## 3. Using Button Styles
///
/// The themes for `ElevatedButton`, `TextButton`, and `OutlinedButton` are already defined.
/// You can use these buttons directly in your widgets, and they will automatically
/// adopt the styles defined in the theme.
///
/// `dart
/// ElevatedButton(
///   onPressed: () {},
///   child: Text('Elevated Button'),
/// );
///
/// TextButton(
///   onPressed: () {},
///   child: Text('Text Button'),
/// );
///
/// OutlinedButton(
///   onPressed: () {},
///   child: Text('Outlined Button'),
/// );
/// `
///
/// ## 4. Using Input Decoration for TextFields
///
/// The `inputDecorationTheme` provides a default style for all `TextField` widgets.
/// You can simply use a `TextField` and it will have the defined style.
///
/// `dart
/// TextField(
///   decoration: InputDecoration(
///     labelText: 'Username',
///     hintText: 'Enter your username',
///   ),
/// );
/// `
///
/// You can also customize the decoration for a specific `TextField` by using `copyWith`.
///
/// `dart
/// TextField(
///   decoration: Theme.of(context).inputDecorationTheme.copyWith(
///     labelText: 'Password',
///     hintText: 'Enter your password',
///   ),
/// );
/// `
///
/// ## 5. Using Other Theme Components
///
/// Other components like `Card`, `AppBar`, `BottomNavigationBar`, etc., will also
/// automatically use the styles defined in their respective theme data
/// (`cardTheme`, `appBarTheme`, `bottomNavigationBarTheme`, etc.).
///
/// `dart
/// Card(
///   child: Padding(
///     padding: const EdgeInsets.all(16.0),
///     child: Text('This is a card'),
///   ),
/// );
///
/// Scaffold(
///   appBar: AppBar(
///     title: Text('My App'),
///   ),
///   body: Center(
///     child: Text('Hello World'),
///   ),
/// );
/// `
