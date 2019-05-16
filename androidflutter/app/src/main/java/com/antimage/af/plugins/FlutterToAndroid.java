package com.antimage.af.plugins;

import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build;
import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * Created by xuyuming on 2019/5/16.
 */

public class FlutterToAndroid implements MethodChannel.MethodCallHandler {

    private static final String BATTERY_CHANNEL = "com.antimage.af/to_android";

    private Context context;

    private FlutterToAndroid() {}

    private FlutterToAndroid(Context context) {
        this.context = context;
    }

    public static void registerWith(Context context, BinaryMessenger binaryMessenger) {
        MethodChannel methodChannel = new MethodChannel(binaryMessenger, BATTERY_CHANNEL);
        FlutterToAndroid instance = new FlutterToAndroid(context);
        methodChannel.setMethodCallHandler(instance);
    }

    /**
     * 此回调在主线程
     * @param call  call.method与flutter端要匹配。类似于发送一个intent，发送方和接收方要匹配action一样
     * @param result
     */
    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        Log.e(getClass().getSimpleName(), "methodChannel Thread name: " + Thread.currentThread().getName());
        if (call.method.equals("getBatteryLevel")) {
            // 获取flutter传过来的参数
            if (call.hasArgument("where")) {
                Log.d(getClass().getSimpleName(), call.argument("where"));
            }
            int batteryLevel = getBatteryLevel();
            if (batteryLevel != -1) {
                result.success(batteryLevel);
            } else {
                result.error("unavailable", "Battery level not available.", null);
            }
        } else {
            result.notImplemented();
        }
    }

    //获取电池电量
    private int getBatteryLevel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) context.getSystemService(Context.BATTERY_SERVICE);
            return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(context.getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            return (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }
    }
}
