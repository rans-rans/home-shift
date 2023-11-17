package com.rans_innovations.home_shift

import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import java.util.Calendar
import java.util.concurrent.TimeUnit

object WallpaperScheduler {


    fun scheduleWallpaperChange(workManager: WorkManager, initialDelay: Long) {

        val constraints = Constraints.Builder()
            .setRequiresCharging(false)
            .setRequiresDeviceIdle(false)
            .setRequiredNetworkType(NetworkType.CONNECTED)
            .build()

        val workRequest = PeriodicWorkRequestBuilder<WallpaperWorker>(24L, TimeUnit.HOURS)
            .setConstraints(constraints)
            .setInitialDelay(initialDelay, TimeUnit.MILLISECONDS)
            .addTag("wallpaper_change")
            .build()


        workManager.enqueueUniquePeriodicWork(
            "wallpaper_change",
            ExistingPeriodicWorkPolicy.CANCEL_AND_REENQUEUE , // or REPLACE
            workRequest
        )

    }

    fun calculateInitialDelay(hour: Int, minute: Int): Long {
        val currentTime = Calendar.getInstance()
        val desiredTime = Calendar.getInstance().apply {
            set(Calendar.HOUR_OF_DAY, hour)
            set(Calendar.MINUTE, minute)
            set(Calendar.SECOND, 0)
        }

        var initialDelay = desiredTime.timeInMillis - currentTime.timeInMillis
        if (initialDelay <= 0) {
            initialDelay += TimeUnit.DAYS.toMillis(1)
        }

        return initialDelay
    }
}
