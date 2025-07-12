import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime quitDate = DateTime.now();
  late int cigarCount = 0;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final storage = StorageService();
    quitDate = await storage.loadQuitDate() ?? DateTime.now();
    cigarCount = await storage.loadCigarCount() ?? 0;

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildMainContent());
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
            ).then((_) => _loadData());
          },
        ),
      ],
    );
  }

  Widget _buildEmptyContent() {
    return const Center(child: Text('금연 시작일을 설정해주세요'));
  }

  Widget _buildMainContent() {
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final today = DateTime.now();
    final days = today.difference(quitDate).inDays;

    final moneySaved = days * (4500 / 20 * cigarCount);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('금연한지 $days일째!', style: const TextStyle(fontSize: 28)),
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
