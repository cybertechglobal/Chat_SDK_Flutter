import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chat_sdk_flutter_platform_interface.dart';

/// An implementation of [ChatSdkFlutterPlatform] that uses method channels.
class MethodChannelChatSdkFlutter extends ChatSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('chat_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void setAppToken(String appToken) {
    methodChannel
        .invokeMethod<String>(Methods.initChat, {'appToken': appToken});
  }

  @override
  void setUser(BrrmUser user) {
    methodChannel.invokeMethod<String>(Methods.setUser, user.toJson());
  }

  @override
  void setGroup(BrrmGroup group) {
    methodChannel.invokeMethod<String>(Methods.setGroup, group.toJson());
  }

  @override
  void openChat() {
    methodChannel.invokeMethod<String>(Methods.openChat);
  }

  @override
  void setFMCToken(String fmcToken) {
    methodChannel
        .invokeMethod<String>(Methods.setFMCToken, {'FCMToken': fmcToken});
  }
}

class Methods {
  static String initChat = 'initChat';
  static String setUser = 'setUser';
  static String setGroup = 'setGroup';
  static String openChat = 'openChat';
  static String setFMCToken = 'setFCMToken';
}
