import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/material.dart';

import 'app/routes.dart';
import 'app/theme.dart';
import 'core/constants/app_strings.dart';

/// Configures global errors and starts TIKTOKTOK.
void main() {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('TIKTOKTOK Flutter error: ${details.exceptionAsString()}');
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    debugPrint('TIKTOKTOK platform error: $error\n$stackTrace');
    return true;
  };

  ErrorWidget.builder = (_) => Material(
    color: AppTheme.light.scaffoldBackgroundColor,
    child: const Center(child: Text(AppStrings.genericError)),
  );
  runApp(const TikTokTokApp());
}

/// Root Material application.
class TikTokTokApp extends StatelessWidget {
  /// Creates the root application widget.
  const TikTokTokApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppStrings.appName,
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    initialRoute: AppRoutes.login,
    onGenerateRoute: AppRoutes.onGenerateRoute,
  );
}
