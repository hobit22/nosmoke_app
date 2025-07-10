import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DateTime? selectedDate;
  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    loadDate();
  }

  Future<void> loadDate() async {
    final savedDate = await storage.loadQuitDate();
    setState(() {
      selectedDate = savedDate;
    });
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
    );
    if (picked != null) {
      await storage.saveQuitDate(picked);
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate == null
                  ? '금연 시작일을 선택해주세요'
                  : '금연 시작일: ${selectedDate!.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: pickDate, child: const Text('시작일 선택')),
          ],
        ),
      ),
    );
  }
}
