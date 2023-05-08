package com.chrono7.audio_tutor

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioManager
import android.os.Bundle
import android.os.PowerManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.math.roundToInt



class MainActivity : FlutterActivity() {

    private var mAudioManager: AudioManager? = null
    private var mMaxVolume = 0
    private var isVolumeCaptureEnabled = false
    private var lastVolumeUpdate = 0L
    private var wakeLock: PowerManager.WakeLock? = null

    init {
        instance = this
    }

    companion object {
        var instance: MainActivity? = null
        const val TAG = "audioTutorVolBtnService"
        const val VOLUME_CHANGED_ACTION = "android.media.VOLUME_CHANGED_ACTION"
        const val EXTRA_VOLUME_STREAM_TYPE = "android.media.EXTRA_VOLUME_STREAM_TYPE"
        const val EXTRA_PREV_VOLUME_STREAM_VALUE = "android.media.EXTRA_PREV_VOLUME_STREAM_VALUE"
        const val EXTRA_VOLUME_STREAM_VALUE = "android.media.EXTRA_VOLUME_STREAM_VALUE"
        const val WAIT_BETWEEN_VOL_UPDATES_MS = 100
        const val WAKE_LOCK_TIMEOUT_MINUTES = 10
    }


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        mAudioManager = context.applicationContext.getSystemService(AUDIO_SERVICE) as AudioManager
        mMaxVolume = mAudioManager?.getStreamMaxVolume(AudioManager.STREAM_MUSIC) ?: 15

        registerReceiver()
    }

    private var methodChannel: MethodChannel? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.chrono7.audiotutor/volumeservice"
        )

        methodChannel?.setMethodCallHandler(::_methodCallHandler)
    }

    private fun _methodCallHandler(call: MethodCall, result: Result) {
        when (call.method) {
            "enableVolumeCapture" -> isVolumeCaptureEnabled = true
            "disableVolumeCapture" -> isVolumeCaptureEnabled = false
            "setWakeLock" -> setWakeLock()
            "releaseWakeLock" -> releaseWakeLock()
            else -> Log.e(TAG, "ERROR: no method handler for \${call.method}")
        }
    }

    private fun releaseWakeLock() {
        wakeLock?.release()
    }

    private fun setWakeLock() {
        if (wakeLock == null) {
            wakeLock =
                (getSystemService(Context.POWER_SERVICE) as PowerManager).run {
                    newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "AudioTutor::TtsWakeLock")
                }
        }
        wakeLock?.acquire(WAKE_LOCK_TIMEOUT_MINUTES * 60 * 1000L /* minutes */)
    }

    private fun registerReceiver() {
        val receiver = VolumeBroadcastReceiver(::onVolumeChange)
        val filter = IntentFilter()
        filter.addAction(VOLUME_CHANGED_ACTION)
        applicationContext.registerReceiver(receiver, filter)
    }

    private fun onVolumeChange(prevVolume: Int, newVolume: Int) {
        if (!isVolumeCaptureEnabled
            || System.currentTimeMillis() - lastVolumeUpdate < WAIT_BETWEEN_VOL_UPDATES_MS
        ) {
            return
        }

        mAudioManager?.setStreamVolume(AudioManager.STREAM_MUSIC, prevVolume, 0)

        val changeDirection = if (newVolume > prevVolume) {
            1
        } else if (newVolume < prevVolume) {
            -1
        } else {
            0
        }

        methodChannel?.invokeMethod("onVolumeButtonPress", changeDirection)
        lastVolumeUpdate = System.currentTimeMillis()
    }

    fun getCurrentMusicVolume(): Double {
        val currentVolume =
            if (mAudioManager != null) mAudioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC) else -1
        return (currentVolume / mMaxVolume).toDouble()
    }

    fun setVolume(value: Double) {
        val actualValue: Double = if (value > 1.0) {
            1.0
        } else if (value < 0.0) {
            0.0
        } else {
            value
        }
        val volume = (actualValue * mMaxVolume).roundToInt()
        if (mAudioManager != null) {
            try {
                // 设置音量
                mAudioManager!!.setStreamVolume(AudioManager.STREAM_MUSIC, volume, 0)
                if (volume < 1) {
                    mAudioManager!!.adjustStreamVolume(
                        AudioManager.STREAM_MUSIC,
                        AudioManager.ADJUST_LOWER,
                        0
                    )
                }
            } catch (ex: Exception) {
                //禁止日志
                Log.d(TAG, "setVolume Exception:" + ex.message)
            }
        }
    }

    private class VolumeBroadcastReceiver(val listenerCallback: (Int, Int) -> Unit) :
        BroadcastReceiver() {

        override fun onReceive(context: Context, intent: Intent) {
            //媒体音量改变才通知
            if (intent.action == VOLUME_CHANGED_ACTION
                && intent.getIntExtra(EXTRA_VOLUME_STREAM_TYPE, -1)
                == AudioManager.STREAM_MUSIC
            ) {
                val prevVolume = intent.getIntExtra(EXTRA_PREV_VOLUME_STREAM_VALUE, -1)
                val newVolume = intent.getIntExtra(EXTRA_VOLUME_STREAM_VALUE, -1)

                Log.d(
                    TAG, "PREV VOLUME: $prevVolume | NEW VOL: $newVolume"
                )

                listenerCallback(prevVolume, newVolume)
            }
        }
    }
}
