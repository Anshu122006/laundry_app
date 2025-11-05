package com.iiti.laundry

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import androidx.core.view.WindowCompat

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Enable edge-to-edge manually in a backward-compatible way
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
