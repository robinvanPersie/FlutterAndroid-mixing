package com.antimage.af.plugins;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * Created by xuyuming on 2019/5/16.
 */

public class AndroidToFlutter implements EventChannel.StreamHandler {

    //字符串可以随意指定
    private static final String MSG_CHANNEL = "com.antimage.af/to_flutter";

    private Context context;
    private BroadcastReceiver broadcastReceiver;

    private AndroidToFlutter() {}

    private AndroidToFlutter(Context context) {
        this.context = context;
    }

    public static AndroidToFlutter registerWith(PluginRegistry pluginRegistry) {
        PluginRegistry.Registrar registrar = pluginRegistry.registrarFor("com.antimage.af.plugins.AndroidToFlutter");
        EventChannel eventChannel = new EventChannel(registrar.messenger(), MSG_CHANNEL);
        AndroidToFlutter instance = new AndroidToFlutter(registrar.activeContext());
        eventChannel.setStreamHandler(instance);
        return instance;
    }

    /**
     * 如果是在第一个dart页面里注册的通信通道，那么按返回键时不会触发state<T>类的 dispose()回调，且会直接关闭activity，
     * 从而导致EventChannel.StreamHandler的 onCancel()回调不触发，那么broadcastReceiver就没有反注册，logcat中会出现exception。
     * 所以加了个手动反注册的方法。
     *
     * 如果在非第一个dart页面使用通道，只需要重写dispose()方法，在里面调用cancel()方法即可在pop页面时实现反注册
     */
    public void unregister() {
        if (broadcastReceiver != null) {
            this.context.unregisterReceiver(broadcastReceiver);
            broadcastReceiver = null;
        }
    }

    /**
     * 回调都在主线程
     * @param o
     * @param eventSink
     */
    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        Log.e(getClass().getSimpleName(), "eventChannel Thread name: " + Thread.currentThread().getName());
        Log.i(getClass().getSimpleName(),"listen succeed: what o? " + o);
        broadcastReceiver = new MBroad(eventSink);
        context.registerReceiver(broadcastReceiver, new IntentFilter(Intent.ACTION_VIEW));
        context.sendBroadcast(new Intent(Intent.ACTION_VIEW));
    }

    @Override
    public void onCancel(Object o) {
        Log.i(getClass().getSimpleName(), "onCancel() what o? " + o);
        context.unregisterReceiver(broadcastReceiver);
        broadcastReceiver = null;
    }

    private class MBroad extends BroadcastReceiver {

        private EventChannel.EventSink eventSink;

        public MBroad(EventChannel.EventSink eventSink) {
            this.eventSink = eventSink;
        }

        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            eventSink.success("the msg from android native, action: " + action);
        }
    }
}
