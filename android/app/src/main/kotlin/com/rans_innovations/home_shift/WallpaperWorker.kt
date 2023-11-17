package com.rans_innovations.home_shift

import android.content.Context
import android.graphics.BitmapFactory
import androidx.work.CoroutineWorker
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.async
import kotlinx.coroutines.withContext

class WallpaperWorker(
    context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        return withContext(Dispatchers.IO) {
            try {
                val imageInfo = XmlFormatHelper.extractBingImageInfo()

                val networkImageUrl = imageInfo["imageUrl"] as String
                val description = imageInfo["description"] as String
                val subDescription = imageInfo["subDescription"] as String

                val downloadedImageDeferred =
                    async { ImageDownloader(applicationContext).downloadImage(networkImageUrl) }
                val imagePath = downloadedImageDeferred.await()

                if (imagePath != null) {
                    ChangeWallpaper.changeWallpaperForHomeScreen(
                        imagePath,
                        applicationContext
                    )
                    NotificationHelper.showPictureNotification(
                        subDescription,
                        applicationContext,
                        description,
                        BitmapFactory.decodeFile(imagePath)
                    )
                    return@withContext Result.success()
                }
                return@withContext Result.failure()
            } catch (e: Exception) {
                return@withContext Result.failure()
            }
        }
    }
}
