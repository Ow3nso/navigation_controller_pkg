import 'package:flutter/material.dart';
import 'package:navigation_controller_pkg/navigation_controller_pkg.dart';

/// It's a class that holds the routes of the app and notifies listeners when the routes change
class NavigationController with ChangeNotifier {
  String? _pendingRoute;
  /// It's the route that is pending to be navigated to before the user is authenticated
  String? get pendingRoute => _pendingRoute;
  set pendingRoute(String? value) {
    _pendingRoute = value;
    notifyListeners();
  }
  Object? _pendingArguments;
  /// It's the arguments that are pending to be passed to the route that is pending to be navigated to before the user is authenticated
  Object? get pendingArguments => _pendingArguments;
  set pendingArguments(Object? value) {
    _pendingArguments = value;
    notifyListeners();
  }
  Map<String, Widget Function(BuildContext)> get availableRoutes =>
      {...guardedRoutes, ...openRoutes};

  Map<String, Widget Function(BuildContext)> _guardedRoutes = {};

  Map<String, Widget Function(BuildContext)> get guardedRoutes =>
      _guardedRoutes;

  set guardedRoutes(Map<String, Widget Function(BuildContext)> value) {
    _guardedRoutes = {...guardedRoutes, ...value};
    notifyListeners();
  }

  Map<String, Widget Function(BuildContext)> _openRoutes = {};
  Map<String, Widget Function(BuildContext)> get openRoutes =>
      {..._openRoutes, GenesisPage.routeName: (p0) => const GenesisPage()};

  set openRoutes(Map<String, Widget Function(BuildContext)> value) {
    _openRoutes = {...openRoutes, ...value};
    notifyListeners();
  }

  NavigationController.intance(
      {required Map<String, Widget Function(BuildContext)> guardedAppRoutes,
      required Map<String, Widget Function(BuildContext)> openAppRoutes,
      int homeIndex = 0}) {
    guardedRoutes = guardedAppRoutes;
    openRoutes = openAppRoutes;
    currentPage = homeIndex;
  }

  final PageController _pageController = PageController();
  PageController get pageController => _pageController;
  int _currentPage = 0;
  int get currentPage => _currentPage;

  set currentPage(int value) {
    _currentPage = value;
    notifyListeners();
  }

  Future<void> navigateHomePage(int index) async {
    if (index == currentPage) return;
    pageController.jumpToPage(index);
    // await pageController.animateToPage(index,
    //     duration: const Duration(milliseconds: 200), curve: Curves.bounceOut);
    updateVisitedAlfas(index);
    currentPage = index;
  }

  bool activePage(int index) => currentPage == index;
  final List<int> _visitedAlphaPages = [0];
  List<int> get visitedAlphaPages => _visitedAlphaPages;
  void updateVisitedAlfas(int index) {
    _visitedAlphaPages.remove(index);
    _visitedAlphaPages.add(index);
  }

  Future<bool> onWillPop(BuildContext context) async {
    int visits = visitedAlphaPages.length;
    if (visits > 1) {
      _visitedAlphaPages.remove(currentPage);
      navigateHomePage(visits - 2);
      return false;
    }
    return true;
  }
}
