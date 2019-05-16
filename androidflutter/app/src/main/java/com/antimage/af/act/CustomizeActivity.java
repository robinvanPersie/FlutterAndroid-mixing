package com.antimage.af.act;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

import com.antimage.af.plugins.AndroidToFlutter;
import com.antimage.af.plugins.FlutterToAndroid;

import io.flutter.app.FlutterActivityDelegate;
import io.flutter.app.FlutterActivityEvents;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterView;

/**
 * 此页面与继承FlutterActivity效果相同，
 * 但是正常开发我们需要继承自己的BaseActivity，
 * 所以此类将展示如何在不继承的情况下，实现继承FlutterActivity的效果
 */
public class CustomizeActivity extends AppCompatActivity implements FlutterView.Provider,
        PluginRegistry, FlutterActivityDelegate.ViewFactory {

    /**
     * delegate里对window进行了设置，例如statusBar不是primaryColor，之后考虑实现自己的delegate来保留material样式
     */
    private final FlutterActivityDelegate delegate = new FlutterActivityDelegate(this, this);
    private final FlutterActivityEvents eventDelegate;
    private final FlutterView.Provider viewProvider;
    private final PluginRegistry pluginRegistry;

    public CustomizeActivity() {
        this.eventDelegate = this.delegate;
        this.viewProvider = this.delegate;
        this.pluginRegistry = this.delegate;
    }

    private AndroidToFlutter androidToFlutter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.eventDelegate.onCreate(savedInstanceState);
        // 这是flutter生成的类，里面什么也没有实现
        GeneratedPluginRegistrant.registerWith(this);

        FlutterToAndroid.registerWith(this, getFlutterView());
        androidToFlutter = AndroidToFlutter.registerWith(this, getFlutterView());
    }

    @Override
    protected void onStart() {
        super.onStart();
        this.eventDelegate.onStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        this.eventDelegate.onResume();
    }

    @Override
    protected void onDestroy() {
        androidToFlutter.unregister();
        this.eventDelegate.onDestroy();
        super.onDestroy();
    }

    @Override
    public void onBackPressed() {
        if (!this.eventDelegate.onBackPressed()) {
            super.onBackPressed();
        }
    }

    @Override
    protected void onStop() {
        this.eventDelegate.onStop();
        super.onStop();
    }

    @Override
    protected void onPause() {
        super.onPause();
        this.eventDelegate.onPause();
    }

    @Override
    protected void onPostResume() {
        super.onPostResume();
        this.eventDelegate.onPostResume();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        this.eventDelegate.onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (!this.eventDelegate.onActivityResult(requestCode, resultCode, data)) {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

    @Override
    protected void onNewIntent(Intent intent) {
        this.eventDelegate.onNewIntent(intent);
    }

    @Override
    protected void onUserLeaveHint() {
        this.eventDelegate.onUserLeaveHint();
    }

    @Override
    public void onTrimMemory(int level) {
        this.eventDelegate.onTrimMemory(level);
    }

    @Override
    public void onLowMemory() {
        this.eventDelegate.onLowMemory();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        this.eventDelegate.onConfigurationChanged(newConfig);
    }

    @Override
    public FlutterView createFlutterView(Context context) {
        return null;
    }

    @Override
    public FlutterNativeView createFlutterNativeView() {
        return null;
    }

    @Override
    public boolean retainFlutterNativeView() {
        return false;
    }

    @Override
    public Registrar registrarFor(String pluginKey) {
        return this.pluginRegistry.registrarFor(pluginKey);
    }

    @Override
    public boolean hasPlugin(String key) {
        return this.pluginRegistry.hasPlugin(key);
    }

    @Override
    public <T> T valuePublishedByPlugin(String pluginKey) {
        return this.pluginRegistry.valuePublishedByPlugin(pluginKey);
    }

    @Override
    public FlutterView getFlutterView() {
        return this.viewProvider.getFlutterView();
    }
}
