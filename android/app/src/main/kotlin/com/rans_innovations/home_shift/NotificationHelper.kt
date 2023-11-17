package com.rans_innovations.home_shift

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

object NotificationHelper {

    private const val notificationChannelName = "rans_innovations/home_shift/save_image"
    private const val channelName = "rans_innovations/home_shift"
    private const val notificationId = 1


    fun showPictureNotification(
        subDescription: String,
        context: Context,
        imageDescription: String,
        bitmap: Bitmap
    ) {
        val notificationManager = NotificationManagerCompat.from(context)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel =
                NotificationChannel(
                    notificationChannelName,
                    channelName,
                    NotificationManager.IMPORTANCE_DEFAULT
                )
            notificationManager.createNotificationChannel(channel)
        }

        val builder = NotificationCompat.Builder(context, notificationChannelName)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(subDescription)
            .setContentText(imageDescription)
            .setStyle(
                NotificationCompat.BigPictureStyle()
                    .bigPicture(bitmap)
            )
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
        notificationManager.notify(notificationId, builder.build())
    }


}