import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AuthGenesisPage,
        FirebaseAuth,
        FirebaseFirestore,
        Helpers,
        ReadContext,
        UserRepository;
import 'package:navigation_controller_pkg/src/utils/const/constants.dart';
import 'dart:developer' as dev;

import '../../navigation_controller_pkg.dart';
import '../navigation_scaffold/widgets/bottom_navigation.dart';

/// `GenesisPage` is a `PageView` that displays the `BottomNavBar` and the `PageView`'s `itemBuilder`
/// returns the `Widget` returned by the `NavigationController`'s `availableRoutes` `Map` for the
/// `route` of the `PageView`'s `itemBuilder`'s `i` parameter
class GenesisPage extends StatefulWidget {
  static const routeName = '/';
  const GenesisPage({super.key});

  @override
  State<GenesisPage> createState() => _GenesisPageState();
}

class _GenesisPageState extends State<GenesisPage> with WidgetsBindingObserver {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> updateLastSeen() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await _firestore.collection('users').doc(userId).update({
        'lastSeen': DateTime.now().millisecondsSinceEpoch,
      });
      Helpers.debugLog('Last seen updated');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.resumed) {
      try {
        updateLastSeen();
      } catch (e) {
        Helpers.debugLog("Unable to update last seen, error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => context.read<NavigationController>().onWillPop(context),
      child: Scaffold(
        body: PageView.builder(
            itemCount: Constants.alfaPages.length,
            controller: context.read<NavigationController>().pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (i) {
              if (_routeRegistered(context, i)) {
                if (context
                            .read<NavigationController>()
                            .guardedRoutes[Constants.alfaPages[i]] !=
                        null &&
                    !context.read<UserRepository>().userAuthenticated) {
                  NavigationService.navigate(
                      context, AuthGenesisPage.routeName);
                  return;
                }
                context.read<NavigationController>().currentPage = i;
                return;
              }
              if (kDebugMode) {
                dev.log(
                    'major route ${_route(i)} has not been added to NavigationController availableRoutes, please add it to navigate ',
                    error: 'Unregistered route');
              }
            },
            itemBuilder: (_, i) {
              final route = Constants.alfaPages[i];
              if (context.read<NavigationController>().availableRoutes[route] ==
                  null) {
                return Center(
                  child: Text('Comming soon $route '),
                );
              }

              return context
                  .read<NavigationController>()
                  .availableRoutes[route]!(context);
            }),
        bottomNavigationBar: BottomNavBar(
          key: const Key('bottom-nav-bar'),
          currentPath: Constants
              .alfaPages[context.read<NavigationController>().currentPage],
        ),
      ),
    );
  }

  bool _routeRegistered(BuildContext context, int i) {
    return context.read<NavigationController>().availableRoutes[_route(i)] !=
            null ||
        context
                .read<NavigationController>()
                .availableRoutes[_route(i).replaceAll('/', '')] !=
            null;
  }

  String _route(int i) => Constants.alfaPages[i] ?? '';
}
