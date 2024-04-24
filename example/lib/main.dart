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
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNiMTg2MjQxLWQ2YzktNDdmZS05NWZiLTEyYmJiOTE3ZjkwYiIsImlhdCI6MTY5OTUyOTE5MX0.KGfgNuJADwDh_ODeEIPnE-HSxNCuEpeDrtNEs9yBHQw';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('Message received: ${message.data}');
  await BrrmChatPlugin().notificationReceived(message.data);
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
      widget.chatPlugin.notificationReceived(message.data);
    });

    // Handler for receiving push message while application is in a quit state
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> setupChatData() async {
    BrrmUser user = BrrmUser(
        id: '10eb325e-1299-4901-96ca-a6e7fb235cbd',
        email: 'ios@myauto.com',
        name: 'IOS');
    widget.chatPlugin.setUser(user);

    BrrmGroup group = BrrmGroup(
        id: 'e92d4539-25ca-4a19-b0fc-34d6e9ba08d8', name: 'CHAT TEST');
    widget.chatPlugin.setGroup(group);
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
            child: TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () async {
            await setupChatData();
            await widget.chatPlugin.openChat();
          },
          child: const Text('Open Chat'),
        )),
      ),
    );
  }
}
