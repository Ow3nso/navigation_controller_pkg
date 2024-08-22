import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show AuthGenesisPage, NavigationController, ReadContext, UserRepository;

class NavigationService {
  /// > It navigates the user to the specified route, if the route is protected, it navigates the user to
  /// the authentication page
  ///
  /// Args:
  ///   context (BuildContext): The current context of the app
  ///   route (String): The route to navigate to.
  ///   arguments (Object): This is the arguments you want to pass to the next page.
  ///   forever (bool): if set to true, the route will be pushed to the navigation stack forever. Defaults
  /// to false
  ///   popFirst (bool): if true, the current route will be popped before navigating to the new route.
  /// Defaults to false
  ///   retorable (bool): if true, the route will be added to the navigation stack, if false, the route
  /// will be pushed to the navigation stack. Defaults to false
  ///
  /// Returns:
  ///   A function that takes a context and a route name.
  static Future<Object?> navigate(BuildContext context, String route,
      {Object? arguments,
      bool forever = false,
      bool popFirst = false,
      bool retorable = false}) {
    if (!registeredRoute(context, route)) {
      String error =
          'route -> [$route]: is not registed, please register the route in the navigation_controller_pkg package or main app';
      if (kDebugMode) {
        log(error, error: 'Unregistered route');
      }
      throw Exception(error);
    }
    Future<Object?> navigate() {
      return _handleNavigation(context, route,
          arguments: arguments,
          forever: forever,
          popFirst: popFirst,
          retorable: retorable);
    }

    if (_isPublicRoute(context, route)) {
      log('this is a public route $route');
      return navigate();
    }

    // if user is un-authenticated and the route is guarded

    if (userRepository(context).userAuthenticated) {
      return navigate();
    }

    if (kDebugMode) {
      log('This is a protected route => [$route]: Navigating user to authentication');
    }

    context.read<NavigationController>().pendingRoute = route;
    context.read<NavigationController>().pendingArguments = arguments;

    return Navigator.pushNamed(context, AuthGenesisPage.routeName, arguments: arguments);
  }

  static bool _isPublicRoute(BuildContext context, String route) =>
      navigationController(context).openRoutes[route] != null ||
      navigationController(context).openRoutes[route.replaceAll('/', '')] !=
          null;

  /// It navigates the user to the given route
  ///
  /// Args:
  ///   context (BuildContext): The context of the current screen.
  ///   route (String): The route name to navigate to.
  ///   arguments (Object): This is the data that you want to pass to the next screen.
  ///   forever (bool): If true, the current route will be replaced with the new route. Defaults to false
  ///   popFirst (bool): If true, the current screen will be popped before navigating to the new screen.
  /// Defaults to false
  ///   retorable (bool): If true, the route will be added to the stack of routes. Defaults to false
  static Future<Object?> _handleNavigation(BuildContext context, String route,
      {Object? arguments,
      bool forever = false,
      bool popFirst = false,
      bool retorable = false}) {
    if (kDebugMode) {
      log('Navigating user to -> $route');
    }
    if (forever) {
      return Navigator.pushReplacementNamed(context, route,
          arguments: arguments);
    } else if (popFirst) {
      return Navigator.popAndPushNamed(context, route, arguments: arguments);
    } else {
      return Navigator.pushNamed(context, route, arguments: arguments);
    }
  }

  /// It checks if the route is registered in the navigation controller
  ///
  /// Args:
  ///   context (BuildContext): The context of the current screen.
  ///   route (String): The route to navigate to.
  ///
  /// Returns:
  ///   A boolean value.
  static bool registeredRoute(BuildContext context, String route) {
    return navigationController(context).availableRoutes[route] != null ||
        navigationController(context)
                .availableRoutes[route.replaceAll('/', '')] !=
            null;
  }

  /// It returns the NavigationController instance that is stored in the context's InheritedWidget tree.
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is calling the navigation controller.
  static NavigationController navigationController(BuildContext context) =>
      context.read<NavigationController>();

  /// `context.read<UserRepository>()`
  ///
  /// This function is used to get the instance of the `UserRepository` class
  ///
  /// Args:
  ///   context (BuildContext): The BuildContext of the widget that calls the function.
  static UserRepository userRepository(BuildContext context) =>
      context.read<UserRepository>();

  /// Used to get the current context of the app.
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// It navigates to the route specified by the route parameter.
  ///
  /// Args:
  ///   route (String): The route name to navigate to.
  ///   arguments (Object): The arguments you want to pass to the next page.
  ///   forever (bool): If true, the route will be added to the stack forever. Defaults to false
  ///   popFirst (bool): If true, the current page will be popped before navigating to the new page.
  /// Defaults to false
  ///   retorable (bool): If true, the route will be added to the stack of routes. Defaults to false
  static Future<Object?> navigateGlobally(
      {required String route,
      Object? arguments,
      bool forever = false,
      bool popFirst = false,
      bool retorable = false}) {
    try {
      BuildContext context = navigatorKey.currentContext!;
      return navigate(context, route,
          arguments: arguments,
          forever: forever,
          popFirst: popFirst,
          retorable: retorable);
    } catch (e) {
      throw Error();
    }
  }
}
