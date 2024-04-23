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
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
