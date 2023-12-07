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
import android.graphics.Paint

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

internal class NativeView @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP) constructor(
    context: Context?, 
    id: Int, 
    creationParams: Map<String?, Any?>?
) : PlatformView {

    private val view = YellowBoxView(context)

    override fun getView(): View? {
        return view
    }

    override fun dispose() {}
}

private class YellowBoxView(context: Context?) : View(context) {
    private val paint = Paint().apply {
        color = Color.YELLOW
    }

    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        canvas?.drawRect(0f, 0f, width.toFloat(), height.toFloat(), paint)
    }
}