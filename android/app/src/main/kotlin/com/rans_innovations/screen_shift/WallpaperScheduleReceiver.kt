package com.rans_innovations.screen_shift

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.async
import kotlinx.coroutines.launch

class WallpaperScheduleReceiver : BroadcastReceiver() {

    private val coroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    override fun onReceive(context: Context?, intent: Intent?) {

        when (intent?.action) {

            Intent.ACTION_BOOT_COMPLETED -> {
                context?.also {
                    val sharedPreferencesData = Helpers.parseXMLFromPreferences(it)
                    sharedPreferencesData?.also { prefsData ->
                        val settingsData = Helpers.convertStringToMap(prefsData)
                        val shouldSchedule = settingsData["automaticallyChangeWallpaper"] as Boolean
                        if (!shouldSchedule) return
                        val hour = settingsData["wallpaper_change_hour"] as Int
                        val minute = settingsData["wallpaper_change_minute"] as Int
                        val initialDelay = Helpers.calculateInitialDelay(hour, minute)
                        WallpaperScheduler(it).scheduleWallpaperChange(initialDelay)
                    }
                }
            }

            "SCHEDULING_WALLPAPER" -> {
                context?.also {
                    getTodayWallpaper(it)
                }
            }
        }
    }

    private fun getTodayWallpaper(context: Context) {
        coroutineScope.launch(Dispatchers.Main) {
            val imageInfoDeferred = async {
                Helpers.getTodayWallpaperData()
            }
            val imageInfo = imageInfoDeferred.await()

            val networkImageUrl = imageInfo["imageUrl"] as String
            val description = imageInfo["description"] as String
            val subDescription = imageInfo["subDescription"] as String

            val downloadedImageDeferred = async(Dispatchers.IO) {
                ImageDownloader(context).downloadImage(networkImageUrl)
            }
            val imagePath = downloadedImageDeferred.await()

            if (imagePath != null) {
                Helpers.changeWallpaperForHomeScreen(imagePath, context)
                NotificationHelper.showPictureNotification(
                    subDescription,
                    context,
                    description,
                    BitmapFactory.decodeFile(imagePath)
                )
            }
        }
    }


    // Optionally, cancel all coroutines when the receiver is done
//    fun cleanup() {
//        coroutineScope.cancel()  // Cancels all coroutines in this scope if needed
//    }
}
