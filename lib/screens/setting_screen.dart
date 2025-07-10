import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  DateTime? selectedDate;
  final TextEditingController cigarCountController = TextEditingController();

  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final savedDate = await storage.loadQuitDate();
    final savedCigarCount = await storage.loadCigarCount();

    setState(() {
      selectedDate = savedDate;
      if (savedCigarCount != null) {
        cigarCountController.text = savedCigarCount.toString();
      }
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
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveSettings() async {
    if (selectedDate != null) {
      await storage.saveQuitDate(selectedDate!);
    }

    final parsedCigarCount = int.tryParse(cigarCountController.text);
    if (parsedCigarCount != null) {
      await storage.saveCigarCount(parsedCigarCount);
    }

    if (mounted) {
      Navigator.pop(context); // 돌아가기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('금연 시작일', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate == null
                        ? '날짜를 선택해주세요'
                        : '${selectedDate!.toLocal()}'.split(' ')[0],
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(onPressed: pickDate, child: const Text('날짜 선택')),
              ],
            ),
            const SizedBox(height: 24),
            const Text('하루 흡연 개수', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextField(
              controller: cigarCountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '예: 10',
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: saveSettings,
                child: const Text('저장하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
