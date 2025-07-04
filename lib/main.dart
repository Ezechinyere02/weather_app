import 'package:flutter/material.dart';
import 'package:weather_app/pages/login.dart';
import 'pages/drawer.dart';
import 'package:weather_app/pages/secondpage.dart';
import 'pages/signup.dart';
import 'package:weather_app/pages/frontpage.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/secondpage',
      routes: {
        '/signup': (context) => SignUpScreen(),
        '/secondpage': (context) => HomePage(),
        '/login': (context) => LoginScreen(),
        '/frontpage': (context) => FrontPage(),
        '/drawer': (context) => UserInfo(),
      },
    );
  }
}
