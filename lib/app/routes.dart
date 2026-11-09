import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../features/auth/login_screen.dart';
import '../features/posts/post_screen.dart';
import '../features/profile/profile_screen.dart';
import '../models/demo_data.dart';
import '../models/user_post.dart';
import '../services/comment_storage_service.dart';

/// Defines named application routes and their dependencies.
abstract final class AppRoutes {
  /// Login route name.
  static const login = '/';

  /// Profile route name.
  static const profile = '/profile';

  /// Post detail route name.
  static const post = '/post';

  /// Builds the route requested by the navigator.
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );
      case profile:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => ProfileScreen(account: DemoData.account),
        );
      case post:
        final post = settings.arguments;
        if (post is! UserPost) {
          return _errorRoute(settings);
        }
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => PostScreen(
            post: post,
            account: DemoData.account,
            storage: CommentStorageService(),
          ),
        );
      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) =>
      MaterialPageRoute<void>(
        settings: settings,
        builder: (_) =>
            const Scaffold(body: Center(child: Text(AppStrings.genericError))),
      );
}
