package com.antimage.af;

import android.app.Application;

import io.flutter.view.FlutterMain;

/**
 * Created by xuyuming on 2019/5/16.
 */

public class App extends Application {

    @Override
    public void onCreate() {
        super.onCreate();
        FlutterMain.startInitialization(this);
    }
}
