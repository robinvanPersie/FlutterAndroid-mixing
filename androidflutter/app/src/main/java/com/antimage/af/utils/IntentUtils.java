package com.antimage.af.utils;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import com.antimage.af.R;

/**
 * Created by xuyuming on 2019/4/17.
 */

public class IntentUtils {

    private static final String COUPON_APP_URL = "taobao://uland.taobao.com/quan/detail?sellerId=%d&activityId=%s";
    private static final String COUPON_BROWSER_URL = "https://uland.taobao.com/quan/detail?sellerId=%d&activityId=%s";
    private static final String TAOBAO_PACK = "com.taobao.taobao";

    private static final String TAOBAO_PRODUCT_H5 = "https://detail.tmall.com/item.htm?id=%d";
    private static final String TMALL_PRODUCT_H5 = "https://item.taobao.com/item.htm?id=%d";

    public static void openTaobaoCoupon(Context context, String actLink) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        boolean install = DeviceUtils.isAppAvilible(context, TAOBAO_PACK);
        if (install) {
            actLink = actLink.replace("https", "taobao").replace("http", "taobao");
            intent.setData(Uri.parse(actLink));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
            return;
        }
        BrowserUtils.openBrowser(context, actLink);
    }

    public static void openProductH5(Context context, long goodsId, int isTmall) {
//        String url = isTmall == 1 ? TMALL_PRODUCT_H5 : TAOBAO_PRODUCT_H5;
//        url = String.format(url, goodsId);
//        Intent intent = new Intent(context, WebViewActivity.class);
//        intent.putExtra("url", url);
//        context.startActivity(intent);
    }

    public static void shareDownloadLink(Context context) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
//        String text = "复制此链接，使用浏览器打开即可下载淘气星球 https://download.shoufuyou.com/tqx/android/app.apk";
        String text = "复制此链接，使用浏览器打开即可下载淘气星球 http://u6.gg/swY6c";
        intent.putExtra(Intent.EXTRA_TEXT, text);
        context.startActivity(Intent.createChooser(intent, context.getString(R.string.app_name)));
    }

}
