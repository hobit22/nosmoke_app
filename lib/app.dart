import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'screens/home_screen.dart';
import 'package:http/http.dart' as http;

class NoSmokeApp extends StatefulWidget {
  const NoSmokeApp({super.key});

  @override
  State<NoSmokeApp> createState() => _NoSmokeAppState();
}

class _NoSmokeAppState extends State<NoSmokeApp> {
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  Future<void> _initFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // 알림 권한 요청 (iOS 포함)
    NotificationSettings settings = await messaging.requestPermission();
    print('알림 권한 상태: ${settings.authorizationStatus}');

    // 토큰 가져오기
    String? token = await messaging.getToken();
    print('🔥 FCM 토큰: $token');
    await sendFcmTokenToServer(token!, '1');

    setState(() {
      _fcmToken = token;
    });

    // 토큰 갱신 감지
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('🔁 FCM 토큰 갱신됨: $newToken');
      sendFcmTokenToServer(newToken, '1');
    });
  }

  Future<void> sendFcmTokenToServer(String fcmToken, String userId) async {
    const serverUrl = 'http://10.0.2.2:8080/api/fcm-token';

    final response = await http.post(
      Uri.parse(serverUrl),
      headers: {'Content-Type': 'application/json'},
      body: '{"userId": "$userId", "fcmToken": "$fcmToken"}',
    );

    if (response.statusCode == 200) {
      print('✅ FCM 토큰 전송 성공');
    } else {
      print('❌ FCM 토큰 전송 실패: ${response.statusCode}');
    }
  }

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
