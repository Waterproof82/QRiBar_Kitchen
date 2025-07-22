package com.qribar.bar // Your actual package name

import io.flutter.embedding.android.FlutterFragmentActivity // Import this!

// Change FlutterActivity to FlutterFragmentActivity
class MainActivity: FlutterFragmentActivity() {
    // You might also have a configureFlutterEngine method here,
    // but it's not strictly necessary for this fix if it's not overridden.
    // If you have it, keep it. Example:
    // override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    //     super.configureFlutterEngine(flutterEngine)
    //     GeneratedPluginRegistrant.registerWith(flutterEngine)
    // }
}