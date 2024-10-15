package com.rans_innovations.screen_shift

import android.content.Context
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.util.Date

class ImageDownloader(private val context: Context) {
    suspend fun downloadImage(imageUrl: String): String? = withContext(Dispatchers.IO) {
        val client = OkHttpClient()
        val request = Request.Builder().url(imageUrl).build()
        val response: Response

        try {
            response = client.newCall(request).execute()
        } catch (e: IOException) {
            return@withContext null
        }

        if (response.isSuccessful) {
            val inputStream: InputStream? = response.body?.byteStream()
            if (inputStream != null) {
                return@withContext saveImageToFile(inputStream, Date().toString())
            }
        }

        return@withContext null
    }

    private fun saveImageToFile(inputStream: InputStream, filename: String): String {
        val directory = File(context.getExternalFilesDir(null), "Home Shift")
        if (!directory.exists()) {
            directory.mkdirs()
        }

        val file = File(directory, filename)
        val outputStream = FileOutputStream(file)
        val buffer = ByteArray(8192)
        var bytesRead: Int

        while (inputStream.read(buffer).also { bytesRead = it } != -1) {
            outputStream.write(buffer, 0, bytesRead)
        }

        outputStream.close()
        inputStream.close()

        return file.absolutePath
    }
}