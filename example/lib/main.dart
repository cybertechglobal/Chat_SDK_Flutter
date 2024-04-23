import 'package:chat_sdk_flutter/brrm_group.dart';
import 'package:chat_sdk_flutter/brrm_user.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:chat_sdk_flutter/chat_sdk_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _chatSdkFlutterPlugin = ChatSdkFlutter();

  @override
  void initState() {
    super.initState();
    //c initPlatformState();

    String appToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjNiMTg2MjQxLWQ2YzktNDdmZS05NWZiLTEyYmJiOTE3ZjkwYiIsImlhdCI6MTY5OTUyOTE5MX0.KGfgNuJADwDh_ODeEIPnE-HSxNCuEpeDrtNEs9yBHQw';

    _chatSdkFlutterPlugin.setAppToken(appToken);

    BrrmUser user = BrrmUser(
        id: '10eb325e-1299-4901-96ca-a6e7fb235cbd',
        email: 'ios@myauto.com',
        name: 'IOS');
    _chatSdkFlutterPlugin.setUser(user);

    BrrmGroup group = BrrmGroup(
        id: 'e92d4539-25ca-4a19-b0fc-34d6e9ba08d8', name: 'CHAT TEST');
    _chatSdkFlutterPlugin.setGroup(group);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _chatSdkFlutterPlugin.getPlatformVersion() ??
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
            _chatSdkFlutterPlugin.openChat();
          },
          child: const Text('Open Chat'),
        )),
      ),
    );
  }
}
