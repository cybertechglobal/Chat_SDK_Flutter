import 'package:chat_sdk_flutter/brrm_group.dart';
import 'package:chat_sdk_flutter/brrm_user.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'chat_sdk_flutter_method_channel.dart';

abstract class ChatSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a ChatSdkFlutterPlatform.
  ChatSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatSdkFlutterPlatform _instance = MethodChannelChatSdkFlutter();

  /// The default instance of [ChatSdkFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelChatSdkFlutter].
  static ChatSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ChatSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(ChatSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void setAppToken(String appToken) {
    throw UnimplementedError('setAppToken() has not been implemented.');
  }

  void setUser(BrrmUser user) {
    throw UnimplementedError('setUser() has not been implemented.');
  }

  void setGroup(BrrmGroup group) {
    throw UnimplementedError('setGroup() has not been implemented.');
  }

  void openChat() {
    throw UnimplementedError('openChat() has not been implemented.');
  }
}
