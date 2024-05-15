package eu.brrm.chat_sdk_flutter

import android.content.Context
import eu.brrm.chatui.BrrmChat
import eu.brrm.chatui.internal.ChatEnvironment
import eu.brrm.chatui.internal.data.BrrmGroup
import eu.brrm.chatui.internal.data.BrrmUser
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject

/** ChatSdkFlutterPlugin */
class ChatSdkFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private var context: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "chat_sdk_flutter")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            Methods.GET_PLATFORM_VERSION -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            Methods.INIT -> {
                init(call, result)
            }

            Methods.OPEN_CHAT -> {
                openChat(call, result)
            }

            Methods.SET_FCM_TOKEN -> {
                setFcmToken(call, result)
            }

            Methods.REGISTER -> {
                register(call, result)
            }

            Methods.IS_BRRM_CHAT_MESSAGE -> {
                isBrrmChatMessage(call, result)
            }

            Methods.HANDLE_BRRM_CHAT_MESSAGE -> {
                handleBrrmChatMessage(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun handleBrrmChatMessage(call: MethodCall, result: Result) {
        val data = call.arguments as? Map<*, *>

        data?.let {
            BrrmChat.instance.handleBrrmChatMessage(it)
        }
        result.success(true)
    }

    private fun isBrrmChatMessage(call: MethodCall, result: Result) {
        val data = call.arguments as? Map<*, *>
        val isBrrmChatMessage = data?.let { BrrmChat.instance.isBrrmChatMessage(it) } ?: false
        result.success(isBrrmChatMessage)
    }

    private fun register(call: MethodCall, result: Result) {
        val user = call.argument<Map<*, *>>("user")?.let { BrrmUser.fromJSON(JSONObject(it)) }
        val group = call.argument<Map<*, *>>("group")?.let { BrrmGroup.fromJSON(JSONObject(it)) }
        val fcmToken = call.argument<String>("FCMToken")
        if (user != null && group != null) {
            BrrmChat.instance.register(user, group, fcmToken) {
                result.success(it)
            }
        }
    }

    private fun setFcmToken(call: MethodCall, result: Result) {
        call.argument<String>("FCMToken")?.let { token ->
            BrrmChat.instance.subscribeDevice(token) {
                result.success(it)
            }
        }
    }

    private fun init(call: MethodCall, result: Result) {
        context?.let { ctx ->
            val args = call.arguments as Map<*, *>
            val appToken = args["appToken"] as? String
                ?: throw IllegalArgumentException("AppToken must be provided")
            val chatEnv = (args["chatEnv"] as? Int).let {
                ChatEnvironment.entries[it ?: 0]
            }
            BrrmChat.init(ctx, appToken, chatEnv)
        }
        result.success(true)
    }

    private fun openChat(call: MethodCall, result: Result) {
        context?.let {
            BrrmChat.instance.openChatList(it)
        }
        result.success(true)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = null
        channel.setMethodCallHandler(null)
    }
}
