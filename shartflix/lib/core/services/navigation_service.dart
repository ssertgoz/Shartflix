import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static void go(String route, {Object? extra}) {
    navigatorKey.currentContext?.go(route, extra: extra);
  }

  static Future<T?> push<T>(String route, {Object? extra}) {
    return navigatorKey.currentContext?.push<T>(route, extra: extra) ??
        Future.value(null);
  }

  static void pop([Object? result]) {
    navigatorKey.currentContext?.pop(result);
  }

  static void replace(String route, {Object? extra}) {
    navigatorKey.currentContext?.pushReplacement(route, extra: extra);
  }

  static bool canPop() {
    return navigatorKey.currentContext?.canPop() ?? false;
  }
}
