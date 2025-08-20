import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Instance of dioProvider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  /// You can add base URL and other configurations here.
  /// for Example:
  dio.options.baseUrl = 'https://dummyjson.com';
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 3);
  return dio;
});
