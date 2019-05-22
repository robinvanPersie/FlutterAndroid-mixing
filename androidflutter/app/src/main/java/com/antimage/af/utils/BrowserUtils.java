package com.antimage.af.utils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.text.TextUtils;
import android.util.Log;


/**
 * Created by xuyuming on 2019/3/7.
 */

public class BrowserUtils {

    public static void openBrowser(Context context, String url) {
        if (TextUtils.isEmpty(url)) {
            Log.e("BrowserUtils","open browser url cannot be empty");
            return;
        }
        if (!openDefaultBrowser(context, url)) {
            openOtherBrowser(context, url);
        }
    }

    /**
     * 直接打开浏览器
     * @return
     */
    private static boolean openDefaultBrowser(Context context, String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(url));
        intent.setClassName("com.android.browser", "com.android.browser.BrowserActivity");
        if (intentUseful(context, intent)) {
            context.startActivity(intent);
            return true;
        }
        return false;
    }

    /**
     * 弹出选择浏览器框
     */
    private static boolean openOtherBrowser(Context context, String url) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse(url));
        if (intentUseful(context, intent)) {
            context.startActivity(intent);
            return true;
        }
        return false;
    }

    /**
     * intent跳转是否可用
     * @return true: 可用 false: 不可用
     */
    static boolean intentUseful(Context context, Intent intent) {
        return intent.resolveActivity(context.getPackageManager()) != null;
    }
}
