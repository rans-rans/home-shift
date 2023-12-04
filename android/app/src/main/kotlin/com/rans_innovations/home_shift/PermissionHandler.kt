package com.rans_innovations.home_shift

import android.app.Activity
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

class PermissionHandler(private val activity: Activity) {

    companion object {
        const val PERMISSION_REQUEST_CODE = 100 // Choose any value you prefer
    }

    fun requestPermissions() {
        val permissionsToRequest =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                arrayOf(
                    android.Manifest.permission.POST_NOTIFICATIONS,
                    )
            } else {
                arrayOf(

                )
            }


        val permissionsNeeded = ArrayList<String>()

        for (permission in permissionsToRequest) {
            if (ContextCompat.checkSelfPermission(
                    activity,
                    permission
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                permissionsNeeded.add(permission)
            }
        }

        if (permissionsNeeded.isNotEmpty()) {
            ActivityCompat.requestPermissions(
                activity,
                permissionsNeeded.toTypedArray(),
                PERMISSION_REQUEST_CODE
            )
        }

    }

}
