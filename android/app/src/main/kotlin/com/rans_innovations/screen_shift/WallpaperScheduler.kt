package com.rans_innovations.screen_shift

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent

class WallpaperScheduler(private val context: Context) {

    private val alarmManager = context.getSystemService(AlarmManager::class.java)


    fun scheduleWallpaperChange(initialDelay: Long) {
        val intent = Intent(context, WallpaperScheduleReceiver::class.java).apply {
            setAction("SCHEDULING_WALLPAPER")
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            99,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.setRepeating(
            AlarmManager.RTC_WAKEUP,
            initialDelay,
            AlarmManager.INTERVAL_DAY,
            pendingIntent
        )
    }

    fun cancelWallpaperSchedule() {
        val intent = Intent(context, WallpaperScheduleReceiver::class.java).apply {
            setAction("SCHEDULING_WALLPAPER")
        }
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            99,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }
}
