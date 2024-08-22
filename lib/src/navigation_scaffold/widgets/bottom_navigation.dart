import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart'
    show
        AuthGenesisPage,
        ReadContext,
        SvgPicture,
        UserRepository,
        WatchContext,
        StyleColors;
import 'package:navigation_controller_pkg/src/utils/const/constants.dart';

import '../../../navigation_controller_pkg.dart';
// import '../../utils/styles/colors.dart';

/// The BottomNavBar class is a stateful widget that contains a list of options that are used to create
/// a row of NavIcon widgets
class BottomNavBar extends StatefulWidget {
  /// Custom home-page bottom navigation bar
  ///
  /// Covers all the primary app navigation pages
  const BottomNavBar({Key? key, this.currentPath}) : super(key: key);
  final String? currentPath;

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List<Map<String, dynamic>> options = [
    {
      'label': 'Home',
      'icon': 'home_icon_duka.svg',
      'route': Constants.homePage
    },
    {
      'label': 'Orders',
      'icon': 'orders_icon_duka.svg',
      'route': Constants.searchPage
    },
    {
      'label': 'Wallet',
      'icon': 'wallet_icon_duka.svg',
      'route': Constants.sellPage,
    },
    {
      'label': 'Products',
      'icon': 'products_icon_duka.svg',
      'route': Constants.inboxPage,
    },
    {
      'label': 'More',
      'icon': 'more_icon_duka.svg',
      'route': Constants.accountPage,
    },
  ];

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double maxSize = max(mediaQueryData.size.width, mediaQueryData.size.height);
    if (kDebugMode) {
      dev.log(ModalRoute.of(context)?.settings.name ?? "");
      dev.log('Current Page => ${widget.currentPath}');
    }
    return Container(
      height: maxSize * .10,
      width: maxSize,
      decoration: BoxDecoration(color: StyleColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
            options.length,
            (i) => NavIcon(
                  svg: options[i]['icon'],
                  label: options[i]['label'],
                  ontap: (_) {
                    // _update(i);
                    if (_routeRegistered(context, i)) {
                      if (context
                                  .read<NavigationController>()
                                  .guardedRoutes[options[i]['route']] !=
                              null &&
                          !context.read<UserRepository>().userAuthenticated) {
                        NavigationService.navigate(
                            context, AuthGenesisPage.routeName);
                        context.read<NavigationController>().pendingRoute =
                            options[i]['route'];
                        return;
                      }
                      context.read<NavigationController>().navigateHomePage(i);

                      return;
                    }
                    if (kDebugMode) {
                      dev.log(
                          'major route ${_route(i)} has not been added to NavigationController availableRoutes, please add it to navigate ',
                          error: 'Unregistered route');
                    }
                  },
                  active: context.watch<NavigationController>().activePage(i),
                )),
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

  String _route(int i) => options[i]['route'];
}

/// It's a stateless widget that takes in an icon, a label, a function to be called on tap, and a
/// boolean to determine if the icon is active or not
class NavIcon extends StatelessWidget {
  /// BottomNavBar icons
  const NavIcon(
      {Key? key,
      required this.svg,
      required this.label,
      required this.ontap,
      this.active = false})
      : super(key: key);

  /// Icon to display
  final String svg;

  /// option label
  final String label;

  /// Status for the option , deafauls to inactive
  final bool active;

  /// action called on tap

  final void Function(int) ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ontap(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/$svg',
            width: 36,
            height: 36,
            // ignore: deprecated_member_use
            color: _color(),
            package: Constants.pluginName,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              label,
              style: TextStyle(
                color: _color(),
                fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          )
        ],
      ),
    );
  }

  Color _color() =>
      active ? StyleColors.lukhuBlue : StyleColors.homeOptionsInactive;
}
