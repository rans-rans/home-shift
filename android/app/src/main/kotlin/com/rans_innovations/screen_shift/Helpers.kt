package com.rans_innovations.screen_shift

import android.app.WallpaperManager
import android.content.Context
import android.graphics.BitmapFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import org.json.JSONObject
import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserFactory
import java.io.StringReader
import java.time.Duration
import java.time.LocalDateTime
import java.time.LocalTime

object Helpers {

    fun calculateInitialDelay(hour: Int, minute: Int): Long {
        val currentTime = LocalDateTime.now()
        val targetTime = LocalTime.of(hour, minute)

        val targetDateTime = LocalDateTime.of(currentTime.toLocalDate(), targetTime)

        return if (currentTime.isBefore(targetDateTime)) {
            Duration.between(currentTime, targetDateTime).toMillis()
        } else {
            Duration.between(
                currentTime, targetDateTime.plusDays(1)
            ).toMillis()
        }

    }

    fun changeWallpaperForHomeScreen(imagePath: String, context: Context) {
        val wallpaperManager = WallpaperManager.getInstance(context)
        val bitmap = BitmapFactory.decodeFile(imagePath)

        wallpaperManager.setBitmap(
            bitmap, null, false, WallpaperManager.FLAG_SYSTEM
        )
    }

    fun convertStringToMap(jsonString: String): Map<String, Any> {
        val map = mutableMapOf<String, Any>()
        val jsonObject = JSONObject(jsonString)

        val keys = jsonObject.keys()
        while (keys.hasNext()) {
            val key = keys.next()
            val value = jsonObject.get(key)
            map.putIfAbsent(key, value)
        }

        return map
    }


    suspend fun getTodayWallpaperData(): Map<*, *> {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url("https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US").build()

        return withContext(Dispatchers.IO) {
            try {
                val response = client.newCall(request).execute()
                if (!response.isSuccessful) {
                    throw Exception("Failed to fetch Bing Image of the Day")
                }

                val xmlResponse = response.body?.string() ?: ""
                response.close()

                val factory = XmlPullParserFactory.newInstance()
                val parser = factory.newPullParser()
                parser.setInput(StringReader(xmlResponse))

                var imageUrl = ""
                var description = ""
                var subDescription = ""
                var eventType = parser.eventType
                while (eventType != XmlPullParser.END_DOCUMENT) {
                    if (eventType == XmlPullParser.START_TAG) {
                        when (parser.name) {
                            "url" -> {
                                parser.next()
                                imageUrl = "https://www.bing.com" + parser.text
                            }

                            "copyright" -> {
                                parser.next()
                                description = parser.text
                            }

                            "headline" -> {
                                parser.next()
                                subDescription = parser.text
                            }
                        }
                    }
                    eventType = parser.next()
                }

                mapOf(
                    "imageUrl" to imageUrl,
                    "description" to description,
                    "subDescription" to subDescription
                )
            } catch (e: Exception) {
                e.printStackTrace()
            } as Map<*, *>
        }

    }

    fun parseXMLFromPreferences(context: Context): String? {
        val sharedPreferences =
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val xmlData = sharedPreferences.getString("flutter.settings", null) ?: return null

        return xmlData
    }
}