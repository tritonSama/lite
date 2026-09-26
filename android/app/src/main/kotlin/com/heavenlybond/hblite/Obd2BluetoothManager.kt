package com.heavenlybond.hblite

import android.Manifest
import android.annotation.SuppressLint
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import com.github.pires.obd.commands.ObdCommand
import com.github.pires.obd.commands.SpeedCommand
import com.github.pires.obd.commands.engine.RPMCommand
import com.github.pires.obd.enums.ObdProtocols
import com.github.pires.obd.commands.protocol.*
import kotlinx.coroutines.*
import java.io.IOException
import java.util.*

object Obd2BluetoothManager {
    private const val TAG = "Obd2BluetoothManager"
    // Standard RFCOMM UUID for OBD2/SPP
    private val UUID_SPP: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

    private var bluetoothSocket: BluetoothSocket? = null
    private var isConnected = false
    private var job: Job? = null

    // Callbacks to pass data up to UI/Flutter
    var onDataUpdate: ((rpm: String, speed: String) -> Unit)? = null
    var onConnectionStateChange: ((Boolean) -> Unit)? = null

    private var currentRpm: String = "0"
    private var currentSpeed: String = "0"

    @SuppressLint("MissingPermission")
    fun connectToDevice(context: Context, deviceAddress: String) {
        if (isConnected) return

        val bluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter = bluetoothManager.adapter

        if (bluetoothAdapter == null) {
            Log.e(TAG, "Device doesn't support Bluetooth")
            return
        }

        val device = bluetoothAdapter.getRemoteDevice(deviceAddress)

        job = CoroutineScope(Dispatchers.IO).launch {
            try {
                bluetoothSocket = device.createRfcommSocketToServiceRecord(UUID_SPP)
                bluetoothSocket?.connect()
                isConnected = true
                Log.i(TAG, "Connected to OBD2 adapter.")

                withContext(Dispatchers.Main) {
                    onConnectionStateChange?.invoke(true)
                }

                initializeObd2()
                startDataPolling(this)

            } catch (e: IOException) {
                Log.e(TAG, "Connection failed", e)
                closeSocket()
            } catch (e: SecurityException) {
                Log.e(TAG, "Missing Bluetooth permissions", e)
                closeSocket()
            }
        }
    }

    private fun initializeObd2() {
        val socket = bluetoothSocket ?: return
        try {
            val inStream = socket.inputStream
            val outStream = socket.outputStream

            Log.i(TAG, "Initializing OBD2 protocol...")
            ObdResetCommand().run(inStream, outStream)
            delaySafely(500)
            EchoOffCommand().run(inStream, outStream)
            LineFeedOffCommand().run(inStream, outStream)
            SpacesOffCommand().run(inStream, outStream)
            HeadersOffCommand().run(inStream, outStream)
            SelectProtocolCommand(ObdProtocols.AUTO).run(inStream, outStream)
            Log.i(TAG, "OBD2 protocol initialized.")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize OBD2", e)
        }
    }

    private fun delaySafely(ms: Long) {
        try {
            Thread.sleep(ms)
        } catch (e: InterruptedException) {
            // Ignore
        }
    }

    private fun startDataPolling(scope: CoroutineScope) {
        scope.launch {
            val socket = bluetoothSocket ?: return@launch
            try {
                val inStream = socket.inputStream
                val outStream = socket.outputStream

                val rpmCommand = RPMCommand()
                val speedCommand = SpeedCommand()

                while (scope.isActive && isConnected) {
                    try {
                        rpmCommand.run(inStream, outStream)
                        currentRpm = rpmCommand.calculatedResult

                        speedCommand.run(inStream, outStream)
                        currentSpeed = speedCommand.calculatedResult

                        Log.d(TAG, "RPM: $currentRpm, Speed: $currentSpeed")

                        withContext(Dispatchers.Main) {
                            onDataUpdate?.invoke(currentRpm, currentSpeed)
                        }

                        delay(500) // Poll every 500ms
                    } catch (e: Exception) {
                        Log.e(TAG, "Error reading OBD2 data", e)
                        break
                    }
                }
            } finally {
                closeSocket()
            }
        }
    }

    fun getLatestData(): Pair<String, String> {
        return Pair(currentRpm, currentSpeed)
    }

    fun isCurrentlyConnected(): Boolean {
        return isConnected
    }

    fun disconnect() {
        closeSocket()
    }

    private fun closeSocket() {
        try {
            isConnected = false
            bluetoothSocket?.close()
            bluetoothSocket = null
            job?.cancel()

            CoroutineScope(Dispatchers.Main).launch {
                onConnectionStateChange?.invoke(false)
            }
        } catch (e: IOException) {
            Log.e(TAG, "Could not close the client socket", e)
        }
    }
}
