package com.antimage.af.delegate;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.util.AttributeSet;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;

import com.antimage.af.R;

import org.json.JSONObject;

import java.io.File;
import java.util.ArrayList;

import io.flutter.app.FlutterActivityEvents;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.util.Preconditions;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;
import io.flutter.view.FlutterView;
import io.flutter.view.ResourceUpdater;

/**
 * Created by xuyuming on 2019/5/17.
 */

public class CustomizeDelegate implements FlutterActivityEvents, FlutterView.Provider, PluginRegistry {

//    private static final String SPLASH_SCREEN_META_DATA_KEY = "io.flutter.app.android.SplashScreenUntilFirstFrame";
//    private static final String TAG = "FlutterActivityDelegate";
    private static final WindowManager.LayoutParams matchParent = new WindowManager.LayoutParams(-1, -1);
    private final Activity activity;
    private final ViewFactory viewFactory;
    private FlutterView flutterView;
    private View launchView;

    public CustomizeDelegate(Activity activity, CustomizeDelegate.ViewFactory viewFactory) {
        this.activity = Preconditions.checkNotNull(activity);
        this.viewFactory = Preconditions.checkNotNull(viewFactory);
    }

    @Override
    public FlutterView getFlutterView() {
        return this.flutterView;
    }

    @Override
    public boolean hasPlugin(String key) {
        return this.flutterView.getPluginRegistry().hasPlugin(key);
    }

    @Override
    public <T> T valuePublishedByPlugin(String pluginKey) {
        return this.flutterView.getPluginRegistry().valuePublishedByPlugin(pluginKey);
    }

    @Override
    public Registrar registrarFor(String pluginKey) {
        return this.flutterView.getPluginRegistry().registrarFor(pluginKey);
    }

    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        return this.flutterView.getPluginRegistry().onRequestPermissionsResult(requestCode, permissions, grantResults);
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return this.flutterView.getPluginRegistry().onActivityResult(requestCode, resultCode, data);
    }

    @Override
    public void onCreate(Bundle bundle) {
        if(Build.VERSION.SDK_INT >= 21) {
            Window window = this.activity.getWindow();
//            window.addFlags(-2147483648);
            window.setStatusBarColor(ContextCompat.getColor(activity, R.color.colorPrimaryDark));
//            window.getDecorView().setSystemUiVisibility(1280);
            window.setBackgroundDrawable(new ColorDrawable(0xffffffff));
        }

        String[] args = getArgsFromIntent(this.activity.getIntent());
        FlutterMain.ensureInitializationComplete(this.activity.getApplicationContext(), args);
        this.flutterView = this.viewFactory.createFlutterView(this.activity);
        if(this.flutterView == null) {
            FlutterNativeView nativeView = this.viewFactory.createFlutterNativeView();
            this.flutterView = new FlutterView(this.activity, (AttributeSet)null, nativeView);
            this.flutterView.setLayoutParams(matchParent);
            this.activity.setContentView(this.flutterView);
            this.launchView = this.createLaunchView();
            if(this.launchView != null) {
                this.addLaunchView();
            }
        }
        if(!this.loadIntent(this.activity.getIntent())) {
            String appBundlePath = FlutterMain.findAppBundlePath(this.activity.getApplicationContext());
            if(appBundlePath != null) {
                this.runBundle(appBundlePath);
            }

        }
    }

    private View createLaunchView() {
        if(!this.showSplashScreenUntilFirstFrame().booleanValue()) {
            Log.i("anti-mage", "not show splash");
            return null;
        } else {
            Drawable launchScreenDrawable = this.getLaunchScreenDrawableFromActivityTheme();
            Log.i("anti-mage", "launch screen drawable: " + (launchScreenDrawable == null));
            if(launchScreenDrawable == null) {
                return null;
            } else {
                View view = new View(this.activity);
                view.setLayoutParams(matchParent);
                view.setBackground(launchScreenDrawable);
                return view;
            }
        }
    }

    private Drawable getLaunchScreenDrawableFromActivityTheme() {
        TypedValue typedValue = new TypedValue();
        if(!this.activity.getTheme().resolveAttribute(16842836, typedValue, true)) {
            return null;
        } else if(typedValue.resourceId == 0) {
            return null;
        } else {
            try {
                return this.activity.getResources().getDrawable(typedValue.resourceId);
            } catch (Resources.NotFoundException var3) {
                Log.e("FlutterActivityDelegate", "Referenced launch screen windowBackground resource does not exist");
                return null;
            }
        }
    }

    private Boolean showSplashScreenUntilFirstFrame() {
        try {
            ActivityInfo activityInfo = this.activity.getPackageManager().getActivityInfo(this.activity.getComponentName(), PackageManager.GET_META_DATA);
            Bundle metadata = activityInfo.metaData;
            return Boolean.valueOf(metadata != null && metadata.getBoolean("io.flutter.app.android.SplashScreenUntilFirstFrame"));
        } catch (PackageManager.NameNotFoundException var3) {
            return Boolean.valueOf(false);
        }
    }

    private void addLaunchView() {
        if(this.launchView != null) {
            this.activity.addContentView(this.launchView, matchParent);
            this.flutterView.addFirstFrameListener(new FlutterView.FirstFrameListener() {
                public void onFirstFrame() {
                    launchView.animate().alpha(0.0F).setListener(new AnimatorListenerAdapter() {
                        public void onAnimationEnd(Animator animation) {
                            ((ViewGroup)launchView.getParent()).removeView(launchView);
                            launchView = null;
                        }
                    });
                    flutterView.removeFirstFrameListener(this);
                }
            });
//            this.activity.setTheme(16973833);
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
        if(!this.isDebuggable() || !this.loadIntent(intent)) {
            this.flutterView.getPluginRegistry().onNewIntent(intent);
        }
    }

    private boolean isDebuggable() {
        return (this.activity.getApplicationInfo().flags & 2) != 0;
    }

    @Override
    public void onPause() {
        Application app = (Application)this.activity.getApplicationContext();
        if(app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication)app;
            if(this.activity.equals(flutterApp.getCurrentActivity())) {
                flutterApp.setCurrentActivity(null);
            }
        }

        if(this.flutterView != null) {
            this.flutterView.onPause();
        }
    }

    @Override
    public void onStart() {
        if(this.flutterView != null) {
            this.flutterView.onStart();
        }
    }

    @Override
    public void onResume() {
        Application app = (Application)this.activity.getApplicationContext();
        FlutterMain.onResume(app);
        if(app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication)app;
            flutterApp.setCurrentActivity(this.activity);
        }
    }

    @Override
    public void onPostResume() {
        if(this.flutterView != null) {
            this.flutterView.onPostResume();
        }
    }

    @Override
    public void onDestroy() {
        Application app = (Application)this.activity.getApplicationContext();
        if(app instanceof FlutterApplication) {
            FlutterApplication flutterApp = (FlutterApplication)app;
            if(this.activity.equals(flutterApp.getCurrentActivity())) {
                flutterApp.setCurrentActivity(null);
            }
        }

        if(this.flutterView != null) {
            boolean detach = this.flutterView.getPluginRegistry().onViewDestroy(this.flutterView.getFlutterNativeView());
            if(!detach && !this.viewFactory.retainFlutterNativeView()) {
                this.flutterView.destroy();
            } else {
                this.flutterView.detach();
            }
        }
    }

    @Override
    public void onStop() {
        this.flutterView.onStop();
    }

    @Override
    public boolean onBackPressed() {
        if(this.flutterView != null) {
            this.flutterView.popRoute();
            return true;
        } else {
            return false;
        }
    }

    @Override
    public void onUserLeaveHint() {
        this.flutterView.getPluginRegistry().onUserLeaveHint();
    }

    @Override
    public void onTrimMemory(int level) {
        if(level == 10) {
            this.flutterView.onMemoryPressure();
        }
    }

    @Override
    public void onLowMemory() {
        this.flutterView.onMemoryPressure();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {

    }

    private static String[] getArgsFromIntent(Intent intent) {
        ArrayList<String> args = new ArrayList();
        if(intent.getBooleanExtra("trace-startup", false)) {
            args.add("--trace-startup");
        }

        if(intent.getBooleanExtra("start-paused", false)) {
            args.add("--start-paused");
        }

        if(intent.getBooleanExtra("disable-service-auth-codes", false)) {
            args.add("--disable-service-auth-codes");
        }

        if(intent.getBooleanExtra("use-test-fonts", false)) {
            args.add("--use-test-fonts");
        }

        if(intent.getBooleanExtra("enable-dart-profiling", false)) {
            args.add("--enable-dart-profiling");
        }

        if(intent.getBooleanExtra("enable-software-rendering", false)) {
            args.add("--enable-software-rendering");
        }

        if(intent.getBooleanExtra("skia-deterministic-rendering", false)) {
            args.add("--skia-deterministic-rendering");
        }

        if(intent.getBooleanExtra("trace-skia", false)) {
            args.add("--trace-skia");
        }

        if(intent.getBooleanExtra("trace-systrace", false)) {
            args.add("--trace-systrace");
        }

        if(intent.getBooleanExtra("dump-skp-on-shader-compilation", false)) {
            args.add("--dump-skp-on-shader-compilation");
        }

        if(intent.getBooleanExtra("verbose-logging", false)) {
            args.add("--verbose-logging");
        }

        if(!args.isEmpty()) {
            String[] argsArray = new String[args.size()];
            return (String[])args.toArray(argsArray);
        } else {
            return null;
        }
    }

    private boolean loadIntent(Intent intent) {
        String action = intent.getAction();
        if("android.intent.action.RUN".equals(action)) {
            String route = intent.getStringExtra("route");
            String appBundlePath = intent.getDataString();
            if(appBundlePath == null) {
                appBundlePath = FlutterMain.findAppBundlePath(this.activity.getApplicationContext());
            }

            if(route != null) {
                this.flutterView.setInitialRoute(route);
            }

            this.runBundle(appBundlePath);
            return true;
        } else {
            return false;
        }
    }

    private void runBundle(String appBundlePath) {
        if(!this.flutterView.getFlutterNativeView().isApplicationRunning()) {
            FlutterRunArguments args = new FlutterRunArguments();
            ArrayList<String> bundlePaths = new ArrayList();
            ResourceUpdater resourceUpdater = FlutterMain.getResourceUpdater();
            if(resourceUpdater != null) {
                File patchFile = resourceUpdater.getInstalledPatch();
                JSONObject manifest = resourceUpdater.readManifest(patchFile);
                if(resourceUpdater.validateManifest(manifest)) {
                    bundlePaths.add(patchFile.getPath());
                }
            }

            bundlePaths.add(appBundlePath);
            args.bundlePaths = (String[])bundlePaths.toArray(new String[0]);
            args.entrypoint = "main";
            this.flutterView.runFromBundle(args);
        }

    }

    public interface ViewFactory {
        FlutterView createFlutterView(Context var1);

        FlutterNativeView createFlutterNativeView();

        boolean retainFlutterNativeView();
    }
}
