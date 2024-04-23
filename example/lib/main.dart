import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:chat_sdk_flutter/chat_sdk_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  final chatSdkFlutterPlugin = ChatSdkFlutter();

  final fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken != null) {
    chatSdkFlutterPlugin.setFMCToken(fcmToken);
  }
  runApp(MyApp(chatSdkFlutterPlugin: chatSdkFlutterPlugin));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.chatSdkFlutterPlugin});

  @override
  State<MyApp> createState() => _MyAppState();
  final ChatSdkFlutter chatSdkFlutterPlugin;
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    //c initPlatformState();

    String appToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNiMTg2MjQxLWQ2YzktNDdmZS05NWZiLTEyYmJiOTE3ZjkwYiIsImlhdCI6MTY5OTUyOTE5MX0.KGfgNuJADwDh_ODeEIPnE-HSxNCuEpeDrtNEs9yBHQw';

    widget.chatSdkFlutterPlugin.setAppToken(appToken);

    BrrmUser user = BrrmUser(
        id: '10eb325e-1299-4901-96ca-a6e7fb235cbd',
        email: 'ios@myauto.com',
        name: 'IOS');
    widget.chatSdkFlutterPlugin.setUser(user);

    BrrmGroup group = BrrmGroup(
        id: 'e92d4539-25ca-4a19-b0fc-34d6e9ba08d8', name: 'CHAT TEST');
    widget.chatSdkFlutterPlugin.setGroup(group);

    _firebaseMessaging.requestPermission();

    //Ovo ovde je dodato  jer sam tako video iz firebase dokumentacije i stvarno stizu notifikacije to radi ok ali moja biblioteka nece da prikaze tu notifikaciju
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.data}');
      widget.chatSdkFlutterPlugin.notificationReceived(message.data);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await widget.chatSdkFlutterPlugin.getPlatformVersion() ??
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
          onPressed: () {
            widget.chatSdkFlutterPlugin.openChat();
          },
          child: const Text('Open Chat'),
        )),
      ),
    );
  }
}
