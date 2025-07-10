import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class NoSmokeApp extends StatelessWidget {
  const NoSmokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금연 도우미',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}
