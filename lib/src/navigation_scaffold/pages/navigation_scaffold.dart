
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation.dart';

class NavigationScafold extends StatelessWidget {
  const NavigationScafold({super.key, required this.child, this.currentPath});
  final Widget child;
  final String? currentPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        key: const Key('bottom-nav-bar'),
        currentPath: currentPath,
      ),
    );
  }
}
