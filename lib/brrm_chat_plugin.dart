import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:chat_sdk_flutter/models/chat_environment.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'brrm_chat_plugin_interface.dart';
import 'methods.dart';

/// An implementation of [ChatSdkFlutterPlatform] that uses method channels.
class BrrmChatPlugin extends ChatSdkFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('chat_sdk_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    return methodChannel.invokeMethod(Methods.getPlatformVersion);
  }

  @override
  Future<dynamic> initChat(String appToken,
      [ChatEnvironment? chatEnvironment]) {
    return methodChannel.invokeMethod(Methods.initChat,
        {'appToken': appToken, 'chatEnv': chatEnvironment?.index});
  }

  @override
  Future<dynamic> openChat() {
    return methodChannel.invokeMethod(Methods.openChat);
  }

  @override
  Future<dynamic> setFCMToken(String? fcmToken) {
    return methodChannel
        .invokeMethod(Methods.setFCMToken, {'FCMToken': fcmToken});
  }

  @override
  Future<dynamic> handleBrrmChatMessage(Map<dynamic, dynamic> data) {
    return methodChannel.invokeMethod(Methods.handleBrrmChatMessage, data);
  }

  @override
  Future<dynamic> isBrrmChatMessage(Map<dynamic, dynamic> data) async {
    return methodChannel.invokeMethod(Methods.isBrrmChatMessage, data);
  }

  @override
  Future register(BrrmUser user, BrrmGroup group, [String? token]) {
    Map<dynamic, dynamic> data = {
      'user': user.toJson(),
      'group': group.toJson(),
      "FCMToken": token
    };
    return methodChannel.invokeMethod(Methods.register, data);
  }
}
