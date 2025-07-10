import 'package:flutter/material.dart';

class DatePickerField extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onPick;

  const DatePickerField({
    super.key,
    required this.label,
    required this.date,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                date == null
                    ? '날짜를 선택해주세요'
                    : '${date!.toLocal()}'.split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            TextButton(onPressed: onPick, child: const Text('날짜 선택')),
          ],
        ),
      ],
    );
  }
}
