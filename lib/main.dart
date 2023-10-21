import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youblink/screens/home_screen.dart';
import 'package:youblink/screens/splash_screen.dart';
import 'package:youblink/widgets/navigation_service.dart';

//test
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey:
          navigationService.navigatorKey, // Key for context free dialog alerts
      title: 'Youblink',
      defaultTransition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 1200),
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
    );
  }
}
