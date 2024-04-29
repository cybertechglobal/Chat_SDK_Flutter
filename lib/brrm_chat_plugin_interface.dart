import 'package:chat_sdk_flutter/models/brrm_group.dart';
import 'package:chat_sdk_flutter/models/brrm_user.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'brrm_chat_plugin.dart';

abstract class ChatSdkFlutterPlatform extends PlatformInterface {
  /// Constructs a ChatSdkFlutterPlatform.
  ChatSdkFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatSdkFlutterPlatform _instance = BrrmChatPlugin();

  /// The default instance of [ChatSdkFlutterPlatform] to use.
  ///
  /// Defaults to [BrrmChatPlugin].
  static ChatSdkFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ChatSdkFlutterPlatform] when
  /// they register themselves.
  static set instance(ChatSdkFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion();

  Future<dynamic> initChat(String appToken);

  Future<dynamic> register(BrrmUser user, BrrmGroup group, [String? token]);

  Future<dynamic> openChat();

  Future<dynamic> setFCMToken(String? fcmToken);

  Future<dynamic> isBrrmChatMessage(Map<dynamic, dynamic> data);

  Future<dynamic> handleBrrmChatMessage(Map<dynamic, dynamic> data);
}
