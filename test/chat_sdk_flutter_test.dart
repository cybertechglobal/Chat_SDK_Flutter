import 'package:chat_sdk_flutter/brrm_group.dart';
import 'package:chat_sdk_flutter/brrm_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_sdk_flutter/chat_sdk_flutter.dart';
import 'package:chat_sdk_flutter/chat_sdk_flutter_platform_interface.dart';
import 'package:chat_sdk_flutter/chat_sdk_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockChatSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ChatSdkFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  void openChat() {
    // TODO: implement openChat
  }

  @override
  void setAppToken(String appToken) {
    // TODO: implement setAppToken
  }

  @override
  void setGroup(BrrmGroup group) {
    // TODO: implement setGroup
  }

  @override
  void setUser(BrrmUser user) {
    // TODO: implement setUser
  }
}

void main() {
  final ChatSdkFlutterPlatform initialPlatform = ChatSdkFlutterPlatform.instance;

  test('$MethodChannelChatSdkFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelChatSdkFlutter>());
  });

  test('getPlatformVersion', () async {
    ChatSdkFlutter chatSdkFlutterPlugin = ChatSdkFlutter();
    MockChatSdkFlutterPlatform fakePlatform = MockChatSdkFlutterPlatform();
    ChatSdkFlutterPlatform.instance = fakePlatform;

    expect(await chatSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
