package com.rans_innovations.home_shift

import android.graphics.BitmapFactory
import android.os.Bundle
import android.widget.Toast
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "rans_innovations/home_shift"

    private lateinit var workManager: WorkManager


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        println("---------------------------- on create --------------------------------")
        workManager = WorkManager.getInstance(applicationContext)
    }


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        println("---------------------------- configureFlutterEngine --------------------------------")
        val methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        methodChannel.setMethodCallHandler { call, _ ->
            when (call.method) {
                "show_notification" -> {
                    val arguments = call.arguments as Map<*, *>
                    val imageUrl = arguments["imageUrl"] as String
                    val subDescription = arguments["subDescription"] as String
                    val imageDescription = arguments["imageDescription"] as String
                    val bitmap = BitmapFactory.decodeFile(imageUrl)
                    NotificationHelper.showPictureNotification(
                        subDescription,
                        this,
                        imageDescription,
                        bitmap
                    )
                }


                "schedule_wallpaper" -> {
                    val time = call.arguments as Map<*, *>
                    val hour = time["hour"] as Int
                    val minute = time["minute"] as Int
                    val initialDelay = WallpaperScheduler.calculateInitialDelay(hour, minute)
                    WallpaperScheduler.scheduleWallpaperChange(workManager, initialDelay)
                }

                "cancel_wallpaper" -> {
                    workManager.cancelAllWorkByTag("wallpaper_change")
                }

                "set_wallpaper" -> {
                    val imageUrl = call.arguments as String
                    ChangeWallpaper.changeWallpaperForHomeScreen(
                        imageUrl,
                        applicationContext
                    )
                }

                "show_toast" -> {
                    val message = call.arguments as String
                    Toast.makeText(
                        this,
                        message,
                        Toast.LENGTH_LONG
                    ).show()
                }

            }
        }
    }


}