package eu.brrm.chat_sdk_flutter

import android.content.Context
import eu.brrm.chatui.BrrmChat
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

            Methods.SET_GROUP -> {
                setGroup(call, result)
            }

            Methods.SET_USER -> {
                setUser(call, result)
            }

            Methods.IS_BRRM_CHAT_MESSAGE -> {
                isBrrmChatMessage(call, result)
                result.success(true)
            }

            Methods.HANDLE_BRRM_CHAT_MESSAGE -> {
                handleBrrmChatMessage(call, result)
            }

            Methods.NOTIFICATION_RECEIVED -> {
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

    private fun setUser(call: MethodCall, result: Result) {
        val args = call.arguments as? Map<*, *>
        val user = args?.let { BrrmUser.fromJSON(JSONObject(it)) }
        user?.let {
            BrrmChat.instance.setUser(it)
        }
        result.success(true)
    }

    private fun setGroup(call: MethodCall, result: Result) {
        val args = call.arguments as? Map<*, *>
        val group = args?.let { BrrmGroup.fromJSON(JSONObject(it)) }
        group?.let {
            BrrmChat.instance.setGroup(it)
        }
        result.success(true)
    }

    private fun setFcmToken(call: MethodCall, result: Result) {
        val token = call.argument<String>("FCMToken")
        token?.let {
            BrrmChat.instance.onNewToken(it)
        }
        result.success(true)
    }

    private fun init(call: MethodCall, result: Result) {
        context?.let { ctx ->
            val args = call.arguments as Map<*, *>
            val appToken = args["appToken"] as? String
                ?: throw IllegalArgumentException("AppToken must be provided")
            BrrmChat.init(ctx, appToken)
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
