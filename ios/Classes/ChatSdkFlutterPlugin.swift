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
        case Methods.REGISTER.rawValue:
            guard let args = call.arguments as? [String: Any] else {
                result(false)
                return
            }
            guard let userMap = args["user"] as? [String: Any] else {
                result(false)
                return
            }
            guard let groupMap = args["group"] as? [String: Any] else {
                result(false)
                return
            }
            guard let brrmUser = BrrmUser(json: userMap), let brrmGroup = BrrmGroup(json: groupMap) else {
                result(false)
                return
            }
            
            let fcmToken = args["FCMToken"]

            BrrmChat.shared.register(user: brrmUser, group: brrmGroup,fcmToken:fcmToken)
            result(true)
        case Methods.OPEN_CHAT.rawValue:
            BrrmChat.shared.openChatList()
            result(true)
        case Methods.SET_FCM_TOKEN.rawValue:
            guard let args = call.arguments as? [String: Any], let fcmToken = args["FCMToken"] as? String else {
                result(false)
                return
            }
            BrrmChat.shared.setFMCToken(fmcToken: fcmToken)
            result(true)
        case Methods.HANDLE_BRRM_CHAT_MESSAGE.rawValue:
            guard let args = call.arguments as? [String: Any] else {
                result(false)
                return
            }
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
            result(BrrmChat.shared.isBrrmChatNotification(userInfo: args))

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

enum Methods: String {
    case INIT_CHAT = "initChat"
    case OPEN_CHAT = "openChat"
    case SET_FCM_TOKEN = "setFCMToken"
    case HANDLE_BRRM_CHAT_MESSAGE = "handleBrrmChatMessage"
    case IS_BRRM_CHAT_MESSAGE = "isBrrmChatMessage"

    case REGISTER = "register"
}
