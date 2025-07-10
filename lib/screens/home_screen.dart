import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? quitDate;

  @override
  void initState() {
    super.initState();
    _loadQuitDate();
  }

  Future<void> _loadQuitDate() async {
    final storage = StorageService();
    final savedDate = await storage.loadQuitDate();
    setState(() {
      quitDate = savedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: quitDate == null ? _buildEmptyContent() : _buildMainContent(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('금연 도우미'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            ).then((_) => _loadQuitDate());
          },
        ),
      ],
    );
  }

  Widget _buildEmptyContent() {
    return const Center(child: Text('금연 시작일을 설정해주세요'));
  }

  Widget _buildMainContent() {
    final today = DateTime.now();
    final days = today.difference(quitDate!).inDays;
    final moneySaved = days * (4500 / 20 * 10);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '금연한지 $days일째!',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            '절약한 금액: ${moneySaved.toStringAsFixed(0)}원',
            style: const TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
