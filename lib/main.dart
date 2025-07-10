import 'package:flutter/material.dart';

void main() {
  runApp(NoSmokeApp());
}

class NoSmokeApp extends StatelessWidget {
  const NoSmokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '금연 앱',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DateTime quitDate = DateTime(2024, 7, 1);

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final days = today.difference(quitDate).inDays;

    return Scaffold(
      appBar: AppBar(title: Text('금연 도우미'), centerTitle: true),
      body: Center(
        child: Text(
          '금연한지 $days일째!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
