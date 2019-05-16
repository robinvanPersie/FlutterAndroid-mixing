package com.antimage.af.act;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.ViewGroup;

import com.antimage.af.R;
import com.antimage.af.plugins.AndroidToFlutter;
import com.antimage.af.plugins.FlutterToAndroid;

import io.flutter.facade.Flutter;
import io.flutter.view.FlutterView;

/**
 * 使用Flutter.createView加载, 可以不继承FlutterActivity
 */
public class MainActivity extends AppCompatActivity {

    private FlutterView fv;

    private AndroidToFlutter androidToFlutter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        fv = Flutter.createView(this, getLifecycle(), "route1");
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(-1, -1);
        setContentView(fv, params);

        FlutterToAndroid.registerWith(this, fv);
        androidToFlutter = AndroidToFlutter.registerWith(this, fv);

    }

    @Override
    public void onBackPressed() {
        if (this.fv != null) {
            this.fv.popRoute();
            return;
        }
        super.onBackPressed();
    }

    @Override
    protected void onDestroy() {
        androidToFlutter.unregister();
        super.onDestroy();
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.go_customize) {
            startActivity(new Intent(this, CustomizeActivity.class));
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
