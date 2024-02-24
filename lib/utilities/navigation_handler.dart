import 'package:flutter/material.dart';

class NavigationHandler {
  NavigationHandler._();
  static final NavigationHandler _instance = NavigationHandler._();
  factory NavigationHandler() => _instance;

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute<dynamic>> routeObserver =
      _MyRouteObserver();

  static List<String> navigationStack = [];
}

class _MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint('--------------------------- did push ${route.settings.name}');
      if (route.settings.name != null) {
        NavigationHandler.navigationStack.add(route.settings.name!);
      }
      debugPrint(
        '--------------------------- ${NavigationHandler.navigationStack}',
      );
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint('--------------------------- did pop ${route.settings.name}');
      if (NavigationHandler.navigationStack.isNotEmpty) {
        NavigationHandler.navigationStack.removeLast();
      }
      debugPrint(
        '--------------------------- ${NavigationHandler.navigationStack}',
      );
    }
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute is PageRoute && oldRoute is PageRoute) {
      debugPrint(
        '--------------------------- did replace ${newRoute.settings.name}',
      );
      if (NavigationHandler.navigationStack.isNotEmpty) {
        NavigationHandler.navigationStack.removeLast();
      }
      NavigationHandler.navigationStack.add(newRoute.settings.name ?? '');
      debugPrint(
        '--------------------------- ${NavigationHandler.navigationStack}',
      );
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (route is PageRoute && previousRoute is PageRoute) {
      debugPrint(
        '--------------------------- did remove ${route.settings.name}',
      );
      if (NavigationHandler.navigationStack.isNotEmpty) {
        NavigationHandler.navigationStack.removeLast();
      }
      debugPrint(
        '--------------------------- ${NavigationHandler.navigationStack}',
      );
    }
    super.didRemove(route, previousRoute);
  }
}
