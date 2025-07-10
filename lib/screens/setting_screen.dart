import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../widgets/date_picker_field.dart';
import '../widgets/labeled_number_field.dart';

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
          spacing: 50,
          children: [
            DatePickerField(
              label: '금연 시작일',
              date: selectedDate,
              onPick: pickDate,
            ),
            LabeledNumberField(
              label: '하루에 몇 개비 피우나요?',
              controller: cigarCountController,
              hintText: '예: 10',
            ),
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
