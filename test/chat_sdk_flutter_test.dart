import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_sdk_flutter/brrm_chat_plugin_interface.dart';
import 'package:chat_sdk_flutter/brrm_chat_plugin.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockChatSdkFlutterPlatform
    with MockPlatformInterfaceMixin
    implements ChatSdkFlutterPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future openChat() {
    throw UnimplementedError();
  }

  @override
  Future initChat(String appToken) {
    throw UnimplementedError();
  }

  @override
  Future setGroup(BrrmGroup group) {
    throw UnimplementedError();
  }

  @override
  Future setUser(BrrmUser user) {
    throw UnimplementedError();
  }

  @override
  Future setFCMToken(String fmcToken) {
    throw UnimplementedError();
  }

  @override
  Future notificationReceived(Map<dynamic, dynamic> notification) {
    throw UnimplementedError();
  }

  @override
  Future handleBrrmChatMessage(Map<dynamic, dynamic> data) {
    throw UnimplementedError();
  }

  @override
  Future isBrrmChatMessage(Map<dynamic, dynamic> data) {
    throw UnimplementedError();
  }
}

void main() {
  final ChatSdkFlutterPlatform initialPlatform =
      ChatSdkFlutterPlatform.instance;

  test('$BrrmChatPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<BrrmChatPlugin>());
  });

  test('getPlatformVersion', () async {
    final chatSdkFlutterPlugin = BrrmChatPlugin();
    MockChatSdkFlutterPlatform fakePlatform = MockChatSdkFlutterPlatform();
    ChatSdkFlutterPlatform.instance = fakePlatform;

    expect(await chatSdkFlutterPlugin.getPlatformVersion(), '42');
  });
}
