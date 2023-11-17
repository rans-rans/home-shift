package com.rans_innovations.home_shift

import okhttp3.OkHttpClient
import okhttp3.Request
import org.xmlpull.v1.XmlPullParser
import org.xmlpull.v1.XmlPullParserFactory
import java.io.StringReader

object XmlFormatHelper {
    fun extractBingImageInfo(): Map<String, String> {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url("https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=en-US")
            .build()

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

        return mapOf(
            "imageUrl" to imageUrl,
            "description" to description,
            "subDescription" to subDescription
        )
    }
}