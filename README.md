<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

### This package manages navigatigation and auth-guard for routes

## Features

- Handle Navigation
- Register routes
- Guard protected routes
- Add providers from each package

## Getting started

## Setting up SSH keys

You have to add an SSH key for s a successful `flutter pub get`
This can be done my generating an SSH key locally from your machine and adding it to your profile.


**Install**

Add the follwing line of code to your `pubspec.yaml`

```

dependencies:
  ...
  navigation_controller_pkg:
	git: 
	  url: ggit@github.com:bavon-corp/navigation_controller_pkg.git
	  ref: dev

```


## Usage
# Import package

```dart
import 'package:navigation_controller_pkg/navigation_controller_pkg.dart';
```

# Add all providers to app 

```dart
  runApp(MultiProvider(
    providers: [
      ...NavigationControllers.providers(
          guardedAppRoutes: guardedAppRoutes, openAppRoutes: openAppRoutes)
    ],
    child: const MyApp(),
  ));
```

# Add navigation routes to MaterialApp

```dart
 return MaterialApp(
      title: 'Navigation Doc',
      routes: {...context.read<NavigationController>().availableRoutes},
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      initialRoute: 'home_page',
      onGenerateRoute: NavigationControllers.materialpageRoute,
    );
```

# Navigate to another screen

```dart
  NavigationService.navigate(context, '/');

```

## Additional information
When adding major routes do add add `/` before it.

```dart
   static const routeName = 'search_page';
```

if you want to navigate globally without context you need to add `navigatorKey` at the root `MaterialApp`
```dart
import 'package:lukhu_packages_pkg/lukhu_packages_pkg.dart' show NavigationService;
    MaterialApp(
      title: 'Navigation Doc',
      routes: {...context.read<NavigationController>().availableRoutes},
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: NavigationControllers.materialpageRoute,
      navigatorKey: NavigationService.navigatorKey,
    )
```
To add new features do create a PR from your source branch.
# navigation_controller_pkg
