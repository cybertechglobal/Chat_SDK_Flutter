// ignore_for_file: unused_field

import 'dart:async';

import 'package:chat_sdk_flutter/brrm_chat_plugin.dart';
import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String appToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImM0Y2ZlMGEzLWJkMzctNDAxOC05NWVmLTA5MDI1ZDQyYTQ4MiIsImlhdCI6MTcxNTY4NjY5MH0.yLOfmxVV3Tkh4PPjZsC8IDF4TJBBRFtrXvXd4W3IXTY';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Message received: ${message.data}');
  await BrrmChatPlugin().handleBrrmChatMessage(message.data);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final chatPlugin = BrrmChatPlugin();

  chatPlugin.initChat(appToken);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  if (fcmToken != null) {
    chatPlugin.setFCMToken(fcmToken);
  }

  runApp(MyApp(
    chatPlugin: chatPlugin,
  ));
}

class MyApp extends StatefulWidget {
  final BrrmChatPlugin chatPlugin;

  const MyApp({super.key, required this.chatPlugin});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    //c initPlatformState();

    _firebaseMessaging.requestPermission();

    //Handler for receiving push message while application is in a foreground/background state
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Message received: ${message.data}');
      widget.chatPlugin.handleBrrmChatMessage(message.data);
    });

    // Handler for receiving push message while application is in a quit state
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<dynamic> setupChatData() async {
    BrrmUser user = BrrmUser(
        id: 'e19af7c9-bb04-4dc0-bc78-551acc36f218',
        email: 'sekiprod@user.com',
        name: 'Semsudin Tafilovic');

    BrrmGroup group = BrrmGroup(
        id: '1c0f2e00-6ae7-48a1-a1df-62c5e3138ad3', name: 'TEST DEALERSHIP');
    final token = await FirebaseMessaging.instance.getToken();
    await widget.chatPlugin.register(user, group, token);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await widget.chatPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          children: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                await setupChatData();
              },
              child: const Text('Setup Chat Data'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () async {
                await widget.chatPlugin.openChat();
              },
              child: const Text('Open Chat'),
            ),
          ],
        )),
      ),
    );
  }
}
