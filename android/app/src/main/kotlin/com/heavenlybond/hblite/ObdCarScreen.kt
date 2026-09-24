package com.heavenlybond.hblite

import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.Pane
import androidx.car.app.model.PaneTemplate
import androidx.car.app.model.Row
import androidx.car.app.model.Template
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import android.os.Handler
import android.os.Looper

class ObdCarScreen(carContext: CarContext) : Screen(carContext), DefaultLifecycleObserver {
    private val handler = Handler(Looper.getMainLooper())
    private var isVisible = false

    private val updateRunnable = object : Runnable {
        override fun run() {
            if (isVisible) {
                invalidate() // Triggers onGetTemplate to redraw with latest data
                handler.postDelayed(this, 1000) // Update UI every 1 second
            }
        }
    }

    init {
        lifecycle.addObserver(this)
    }

    override fun onStart(owner: LifecycleOwner) {
        isVisible = true
        handler.post(updateRunnable)
    }

    override fun onStop(owner: LifecycleOwner) {
        isVisible = false
        handler.removeCallbacks(updateRunnable)
    }

    override fun onGetTemplate(): Template {
        val (rpm, speed) = Obd2BluetoothManager.getLatestData()
        val isConnected = Obd2BluetoothManager.isCurrentlyConnected()
        val statusText = if (isConnected) "Connected" else "Disconnected"

        val paneBuilder = Pane.Builder()

        paneBuilder.addRow(
            Row.Builder()
                .setTitle("Engine RPM")
                .addText("$rpm RPM")
                .build()
        )

        paneBuilder.addRow(
            Row.Builder()
                .setTitle("Vehicle Speed")
                .addText("$speed km/h")
                .build()
        )

        paneBuilder.addRow(
            Row.Builder()
                .setTitle("Connection Status")
                .addText(statusText)
                .build()
        )

        return PaneTemplate.Builder(paneBuilder.build())
            .setTitle("OBD2 Telemetry")
            .setHeaderAction(Action.APP_ICON)
            .build()
    }
}
