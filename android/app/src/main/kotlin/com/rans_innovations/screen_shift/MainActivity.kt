package com.rans_innovations.screen_shift

import android.graphics.BitmapFactory
import android.os.Environment
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "rans_innovations/home_shift"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val wallpaperScheduler = WallpaperScheduler(applicationContext)
        val methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        )

        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize_permissions" -> {
                    PermissionHandler(this).requestPermissions()
                }

                "cancel_wallpaper_schedule" -> {
                    wallpaperScheduler.cancelWallpaperSchedule()
                }

                "getExternalStorage" -> {
                    val path =
                        if (Environment.MEDIA_MOUNTED == Environment.getExternalStorageState()) {
                            getExternalFilesDir(null)?.absolutePath // For app-specific external storage
                        } else {
                            null
                        }
                    result.success(path)
                }


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
                    val initialDelay = Helpers.calculateInitialDelay(hour, minute)
                    wallpaperScheduler.scheduleWallpaperChange(initialDelay)
                }


                "set_wallpaper" -> {
                    val imageUrl = call.arguments as String
                    Helpers.changeWallpaperForHomeScreen(
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