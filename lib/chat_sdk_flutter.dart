import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';

import 'chat_sdk_flutter_platform_interface.dart';

class ChatSdkFlutter {
  Future<String?> getPlatformVersion() {
    return ChatSdkFlutterPlatform.instance.getPlatformVersion();
  }

  void setAppToken(String appToken) {
    ChatSdkFlutterPlatform.instance.setAppToken(appToken);
  }

  void setUser(BrrmUser user) {
    ChatSdkFlutterPlatform.instance.setUser(user);
  }

  void setGroup(BrrmGroup group) {
    ChatSdkFlutterPlatform.instance.setGroup(group);
  }

  void openChat() {
    ChatSdkFlutterPlatform.instance.openChat();
  }

  void setFMCToken(String token) {
    ChatSdkFlutterPlatform.instance.setFMCToken(token);
  }

  void notificationReceived(Map<String, dynamic> notification) {
    ChatSdkFlutterPlatform.instance.notificationReceived(notification);
  }
}
