package com.rans_innovations.home_shift

import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import android.os.Build
import java.io.IOException

object ChangeWallpaper {
    fun changeWallpaperForHomeScreen(imagePath: String, context: Context) {
        val wallpaperManager = WallpaperManager.getInstance(context)

        val bitmap = BitmapFactory.decodeFile(imagePath)

        try {

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wallpaperManager.setBitmap(
                    bitmap,
                    null,
                    false,
                    WallpaperManager.FLAG_SYSTEM
                )
            }else{
                wallpaperManager.setBitmap(bitmap)
            }
        } catch (e: IOException) {
            println(e.localizedMessage)
            e.printStackTrace()
        }
    }
}
