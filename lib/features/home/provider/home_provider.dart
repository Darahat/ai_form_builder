import 'package:ai_chat/features/home/application/home_controller.dart';
import 'package:ai_chat/features/home/application/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide HomeController Functions and HomeState's state
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController();
  },
);
