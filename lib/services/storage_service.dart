import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _quitDateKey = 'quit_date';

  Future<void> saveQuitDate(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_quitDateKey, date.toIso8601String());
  }

  Future<DateTime?> loadQuitDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateStr = prefs.getString(_quitDateKey);
    if (dateStr == null) return null;
    return DateTime.tryParse(dateStr);
  }
}
