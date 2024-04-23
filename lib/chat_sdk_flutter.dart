
import 'chat_sdk_flutter_platform_interface.dart';

class ChatSdkFlutter {
  Future<String?> getPlatformVersion() {
    return ChatSdkFlutterPlatform.instance.getPlatformVersion();
  }
}
