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
            result(true)
        case Methods.SET_USER.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            guard let userId = args["id"] as? String,
                  let email = args["email"] as? String,
                  let name = args["name"] as? String else { return }
            let chatUser = BrrmUser(id: userId, email: email, name: name)
            BrrmChat.shared.setUser(user: chatUser)
            result(true)
        case Methods.SET_GROUP.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            guard let groupId = args["id"] as? String,
                  let chatName = args["name"] as? String else { return }
            let group = BrrmGroup(id: groupId, name: chatName)
            BrrmChat.shared.setGroup(group: group)
            result(true)
        case Methods.OPEN_CHAT.rawValue:
            BrrmChat.shared.openChatList()
            result(true)
        case Methods.SET_FCM_TOKEN.rawValue:
            guard let args = call.arguments as? [String: Any], let fcmToken = args["FCMToken"] as? String else { return }
            BrrmChat.shared.setFMCToken(fmcToken: fcmToken)
            result(true)
        case Methods.NOTIFICATION_RECEIVED.rawValue:
            guard let args = call.arguments as? [String: Any] else { return }
            if BrrmChat.shared.isBrrmChatNotification(userInfo: args) {
                BrrmChat.shared.notification(userInfo: args)
                result(true)
            }
            result(false)
        case Methods.IS_BRRM_CHAT_MESSAGE.rawValue:
            guard let args = call.arguments as? [String: Any] else { 
                result(false)
                return 
             }
            result( BrrmChat.shared.isBrrmChatNotification(userInfo: args))
           
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
    case SET_FCM_TOKEN = "setFCMToken"
    case NOTIFICATION_RECEIVED = "notificationReceived"
    case IS_BRRM_CHAT_MESSAGE = "isBrrmChatMessage"
}
