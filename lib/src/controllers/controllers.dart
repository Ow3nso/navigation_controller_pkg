import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AuthGenesisPage,
        AuthRoutes,
        ChangeNotifierProvider,
        ChatRoutes,
        DukastaxRoutes,
        ListingRoutes,
        LukhuPayRoutes,
        ReadContext,
        SalesRoutes,
        SingleChildWidget,
        UserRepository, Provider;

import 'navigation.dart';

/// It's a class that provides a list of providers for the app
class NavigationControllers {
  static List<SingleChildWidget> providers(
      {required Map<String, Widget Function(BuildContext)> guardedAppRoutes,
      required Map<String, Widget Function(BuildContext)> openAppRoutes}) {
    return [
      ChangeNotifierProvider(
          create: (_) => NavigationController.intance(
              openAppRoutes: openAppRoutes,
              guardedAppRoutes: guardedAppRoutes)),

      /// Register other providers
      ...AuthRoutes.authProviders(),
      ...ListingRoutes.listingProviders(),
      ...ChatRoutes.providers(),
      ...SalesRoutes.providers(),
      ...LukhuPayRoutes.providers(),
      ...DukastaxRoutes.providers(),
      Provider<BuildContext>(create: (c) => c),
    ];
  }

  /// If the route is guarded, and the user is not authenticated, show the AuthGenesisPage. If the route
  /// is available, show the route. If the route is not available, show the home page
  ///
  /// Args:
  ///   routeSettings (RouteSettings): This is the route settings that are passed to the route.
  ///
  /// Returns:
  ///   A MaterialPageRoute<void>
  static MaterialPageRoute<void> materialpageRoute(
          RouteSettings routeSettings) =>
      MaterialPageRoute<void>(
        builder: (context) {
          String routeName = routeSettings.name ?? '';
          if (context.read<NavigationController>().guardedRoutes[routeName] !=
                  null &&
              !context.read<UserRepository>().userAuthenticated) {
            return const AuthGenesisPage();
          }

          if (context.read<NavigationController>().availableRoutes[routeName] !=
              null) {
            return context
                .read<NavigationController>()
                .availableRoutes[routeName]!(context);
          }

          return context
              .read<NavigationController>()
              .availableRoutes['home_page']!(context);
        },
      );
}
