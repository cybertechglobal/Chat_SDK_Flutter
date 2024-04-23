import BrrmChatFramework
import Flutter
import UIKit
public class ChatSdkFlutterPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "chat_sdk_flutter", binaryMessenger: registrar.messenger())
        let instance = ChatSdkFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        case Methods.INIT_CHAT.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            guard let token = args["appToken"] as? String else { return }
            BrrmChat.shared.setToken(applicationToken: token)
        // result()
        case Methods.SET_USER.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            guard let userId = args["id"] as? String,
                  let email = args["email"] as? String,
                  let name = args["name"] as? String else { return }
            let chatUser = BrrmUser(id: userId, email: email, name: name)
            BrrmChat.shared.setUser(user: chatUser)
        // result()
        case Methods.SET_GROUP.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            guard let groupId = args["id"] as? String,
                  let chatName = args["name"] as? String else { return }
            let group = BrrmGroup(id: groupId, name: chatName)
            BrrmChat.shared.setGroup(group: group)
        // result()
        case Methods.OPEN_CHAT.rawValue:
            BrrmChat.shared.openChatList()
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

enum Methods: String {
    case INIT_CHAT = "initChat"
    case SET_USER = "setUser"
    case SET_GROUP = "setGroup"
    case OPEN_CHAT = "openChat"
}
