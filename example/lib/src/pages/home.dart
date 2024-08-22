import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});
  static const routeName = 'home_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
    child: Text('Hello Lukhu Navigation'),
      ),
    );
  }
}
