package com.example.bug

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.View
import android.widget.LinearLayout
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory("NativeView", NativeViewFactory())
    }
}


internal class NativeViewFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    override fun create(context: Context, id: Int, args: Any?): PlatformView {
        val creationParams = args as Map<String?, Any?>?
        return NativeView(context, id, creationParams)
    }
}


internal class NativeView @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP) constructor(context: Context?, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    
    private val view = MSurface(context)

    override fun getView(): View? {
        return view
    }

    override fun dispose() {}
    inner class MSurface(context: Context?) : SurfaceView(context), SurfaceHolder.Callback {
        protected fun FillTheCanvas(canvas: Canvas?) {
            canvas!!.drawColor(Color.RED)
        }

        override fun surfaceChanged(holder: SurfaceHolder, format: Int, width: Int, height: Int) {
            // TODO Auto-generated method stub
        }

        @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
        override fun surfaceCreated(holder: SurfaceHolder) {
            var canvas: Canvas? = null
            try {
                canvas = holder.lockCanvas(null)
                synchronized(holder) { FillTheCanvas(canvas) }
            } catch (e: Exception) {
                e.printStackTrace()
            } finally {
                if (canvas != null) {
                    holder.unlockCanvasAndPost(canvas)
                }
            }
        }

        override fun surfaceDestroyed(holder: SurfaceHolder) {
            // TODO Auto-generated method stub
        }

        init {
            holder.addCallback(this)
        }
    }
}