package com.chrono7.audio_tutor

import android.accessibilityservice.AccessibilityService
import android.view.KeyEvent
import android.view.accessibility.AccessibilityEvent

class KeyService : AccessibilityService() {

    override fun onServiceConnected() {}

    override fun onAccessibilityEvent(event: AccessibilityEvent) {}

    override fun onKeyEvent(event: KeyEvent): Boolean {
        when (event.keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP -> {
                when (event.action) {
                    KeyEvent.ACTION_DOWN -> {
                    }
                    KeyEvent.ACTION_UP -> {
                    }
                }
            }
            KeyEvent.KEYCODE_VOLUME_DOWN -> {
                when (event.action) {
                    KeyEvent.ACTION_DOWN -> {
                    }
                    KeyEvent.ACTION_UP -> {
                    }
                }
            }
        }
        return super.onKeyEvent(event)
    }

    override fun onInterrupt() {}
}