package com.heavenlybond.hblite

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val OBD_EVENT_CHANNEL = "com.heavenlybond.hblite/obd_data"
    private val OBD_METHOD_CHANNEL = "com.heavenlybond.hblite/obd_methods"

    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OBD_METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "connectToDevice" -> {
                    val address = call.argument<String>("address")
                    if (address != null) {
                        Obd2BluetoothManager.connectToDevice(context, address)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "MAC address is missing", null)
                    }
                }
                "disconnect" -> {
                    Obd2BluetoothManager.disconnect()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, OBD_EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    setupObdCallbacks()
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    Obd2BluetoothManager.onDataUpdate = null
                    Obd2BluetoothManager.onConnectionStateChange = null
                }
            }
        )
    }

    private fun setupObdCallbacks() {
        Obd2BluetoothManager.onDataUpdate = { rpm, speed ->
            runOnUiThread {
                eventSink?.success(mapOf(
                    "type" to "data",
                    "rpm" to rpm,
                    "speed" to speed
                ))
            }
        }

        Obd2BluetoothManager.onConnectionStateChange = { isConnected ->
            runOnUiThread {
                eventSink?.success(mapOf(
                    "type" to "connection",
                    "isConnected" to isConnected
                ))
            }
        }
    }
}
