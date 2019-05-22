package com.antimage.af.utils;

import android.Manifest;
import android.app.ActivityManager;
import android.app.AppOpsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.telephony.TelephonyManager;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

/**
 * Created by xuyuming on 2019/4/17.
 */

public class DeviceUtils {

    private static long sMaxCpuFreq = 0;
    private static int sTotalMemory = 0;

    //手机CPU主频大小
    public static long getMaxCpuFreq() {
        if (sMaxCpuFreq > 0) {
            return sMaxCpuFreq;
        }
        ProcessBuilder cmd;
        String cpuFreq = "";
        try {
            String[] args = {"/system/bin/cat", "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq"};
            cmd = new ProcessBuilder(args);
            Process process = cmd.start();
            InputStream in = process.getInputStream();
            byte[] re = new byte[24];
            while (in.read(re) != -1) {
                cpuFreq = cpuFreq + new String(re);
            }
            in.close();
        } catch (IOException ex) {
            ex.printStackTrace();
            cpuFreq = "";
        }
        cpuFreq = cpuFreq.trim();
        if (cpuFreq == null || cpuFreq.length() == 0) {
            // 某些机器取到的是空字符串，如：OPPO U701
            sMaxCpuFreq = 1;
        } else {
            try {
                sMaxCpuFreq = Long.parseLong(cpuFreq);
            } catch (NumberFormatException e) {
                sMaxCpuFreq = 1;
                e.printStackTrace();
            }
        }
        return sMaxCpuFreq;
    }

    public static int getTotalMemoryInMb() {
        return getTotalMemoryInKb() >> 10;
    }

    public static int getTotalMemoryInKb() {
        if (sTotalMemory > 0) {
            return sTotalMemory;
        }
        String str1 = "/proc/meminfo";
        String str2 = "";
        String[] arrayOfString;
        FileReader fr = null;
        BufferedReader localBufferedReader = null;
        try {
            fr = new FileReader(str1);
            localBufferedReader = new BufferedReader(fr, 8192);
            if ((str2 = localBufferedReader.readLine()) != null) {

                arrayOfString = str2.split("\\s+");
//                for(String num : arrayOfString){
//                	Log.i(str2, num+"\t");
//                }
                sTotalMemory = Integer.valueOf(arrayOfString[1]).intValue();
            }
        } catch (IOException e) {

        } finally {
            try {
                if (fr != null) {
                    fr.close();
                }
                if (localBufferedReader != null) {
                    localBufferedReader.close();
                }
            } catch (IOException e) {
            }
        }
        return sTotalMemory;
    }

    public static int getFreeMemoryInKb() {
        String str1 = "/proc/meminfo";
        String str2 = "";
        String[] arrayOfString;
        FileReader fr = null;
        BufferedReader localBufferedReader = null;
        int freeMem = 0;
        try {
            fr = new FileReader(str1);
            localBufferedReader = new BufferedReader(fr, 8192);
            int line = 0;
            while ((str2 = localBufferedReader.readLine()) != null) {
                if (++line == 2) {
                    arrayOfString = str2.split("\\s+");
                    freeMem = Integer.valueOf(arrayOfString[1]).intValue();
                    break;
                }
            }
        } catch (IOException e) {

        } finally {
            try {
                if (fr != null) {
                    fr.close();
                }
                if (localBufferedReader != null) {
                    localBufferedReader.close();
                }
            } catch (IOException e) {
            }
        }
        return freeMem;
    }


    /**
     * 获取app vesioncode add by zhenhaiwu
     *
     * @return
     */
    public static int getVersionCode(Context context) {
        try {
//            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(
//                    context.getPackageName(), PackageManager.GET_CONFIGURATIONS);//会获取到已经卸载的消息
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(
                    context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (Exception e) {

        }
        return -1;
    }

    /**
     * 获取app vesionName add by zhenhaiwu
     *
     * @param context
     * @return
     */
    public static String getVersionName(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionName;
        } catch (Exception e) {

        }
        return null;
    }

    /**
     * 获取当前手机系统的最大的可用堆栈大小
     *
     * @return
     */
    public static long getMaxHeapSizeInBytes(Context context) {
        long max = Runtime.getRuntime().maxMemory();
        try {
            ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
            long memoryClass = am.getMemoryClass() << 20;
            if (max > memoryClass) {
                max = memoryClass;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return max;
    }

    /**
     * 获取当前已经分配的堆栈的比例
     *
     * @return
     */
    public static float getHeapAllocatePercent() {
        long heapAllocated = Runtime.getRuntime().totalMemory();
        long heapMax = Runtime.getRuntime().maxMemory();
        return Math.round(heapAllocated * 10000.0f / heapMax) / 100.0f;
    }

    /**
     * 获取当前已经使用的堆栈占总堆栈的比例
     *
     * @return
     */
    public static float getHeapUsedPercent(Context context) {
        long heapUsed = Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory();
        long heapMax = getMaxHeapSizeInBytes(context);
        return Math.round(heapUsed * 10000.0f / heapMax) / 100.0f;
    }

    /**
     * 获取整个max heap里面除去已经使用的heap还可以再分配的heap大小
     *
     * @return
     */
    public static long getHeapRemainInBytes(Context context) {
        return getMaxHeapSizeInBytes(context) - (Runtime.getRuntime().totalMemory() - Runtime.getRuntime().freeMemory());
    }

    public static String getCpuHardware() {
        String r = null;
        ProcessBuilder pb = new ProcessBuilder("/system/bin/cat", "/proc/cpuinfo");
        try {
            Process process = pb.start();
            InputStreamReader inputStreamReader = new InputStreamReader(process.getInputStream());
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String result;
            while ((result = bufferedReader.readLine()) != null) {
                if (result.contains("Hardware")) {
                    String[] a = result.split(":", 2);
                    r = a[1];
                }
            }
            bufferedReader.close();
            return r;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return r;
    }


    public static String getCpuName() {
        String result;
        result = getArmCPUName();
        if (result == null) {
            result = getX86CPUName();
        }
        if (result == null) {
            result = getMIPSCPUName();
        }
        return result;
    }

    public static String getX86CPUName() {
        String aLine = "Intel";
        if (new File("/proc/cpuinfo").exists()) {
            try {
                BufferedReader br = new BufferedReader(new FileReader(new File("/proc/cpuinfo")));
                String strArray[] = new String[2];
                while ((aLine = br.readLine()) != null) {
                    if (aLine.contains("model name")) {
                        br.close();
                        strArray = aLine.split(":", 2);
                        aLine = strArray[1];
                    }
                }
                if (br != null) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return aLine;
    }

    public static String getMIPSCPUName() {
        String aLine = "MIPS";
        if (new File("/proc/cpuinfo").exists()) {
            try {
                BufferedReader br = new BufferedReader(new FileReader(new File("/proc/cpuinfo")));
                String strArray[] = new String[2];
                while ((aLine = br.readLine()) != null) {
                    if (aLine.contains("cpu model")) {
                        br.close();
                        strArray = aLine.split(":", 2);
                        aLine = strArray[1];
                    }
                }
                if (br != null) {
                    br.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return aLine;
    }

    public static String getArmCPUName() {
        try {
            FileReader fr = new FileReader("/proc/cpuinfo");
            BufferedReader br = new BufferedReader(fr);
            String text = br.readLine();
            br.close();
            String[] array = text.split(":\\s+", 2);
            if (array.length >= 2) {
                return array[1];
            }
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 判断手机是否已root
     *
     * @return
     */
    public static boolean isRooted() {
        return findBinary("su");
    }

    private static boolean findBinary(String binaryName) {
        boolean found = false;
        if (!found) {
            String[] places = {"/sbin/", "/system/bin/", "/system/xbin/", "/data/local/xbin/",
                    "/data/local/bin/", "/system/sd/xbin/", "/system/bin/failsafe/", "/data/local/"};
            for (String where : places) {
                if (new File(where + binaryName).exists()) {
                    found = true;
                    break;
                }
            }
        }
        return found;
    }


    /**
     * 判断是否开启位置模拟
     *
     * @param context
     * @return 是否开启位置模拟
     */
    public static boolean isMockLocationEnabled(@NonNull Context context) {
        boolean isMockLocation = false;
        try {
            //if marshmallow
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                AppOpsManager opsManager = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
                isMockLocation = (opsManager.checkOp(AppOpsManager.OPSTR_MOCK_LOCATION, android.os.Process.myUid(), context.getPackageName()) == AppOpsManager.MODE_ALLOWED);
            } else {
                // in marshmallow this will always return true
                isMockLocation = !android.provider.Settings.Secure.getString(context.getContentResolver(), "mock_location").equals("0");
            }
        } catch (Exception e) {
            return isMockLocation;
        }

        return isMockLocation;
    }

    /**
     * 判断是否为虚拟机
     *
     * @return 是否为虚拟机
     */
    public static boolean isEmulator() {
        return Build.FINGERPRINT.startsWith("generic")
                || Build.FINGERPRINT.startsWith("unknown")
                || Build.MODEL.contains("google_sdk")
                || Build.MODEL.contains("Emulator")
                || Build.MODEL.contains("Android SDK built for x86")
                || Build.MANUFACTURER.contains("Genymotion")
                || (Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic"))
                || "google_sdk".equals(Build.PRODUCT);
    }

    /**
     * 获取系统信息
     *
     * @param propName
     * @return
     */
    public static String getSystemProperty(String propName) {
        String line;
        BufferedReader input = null;
        try {
            Process p = Runtime.getRuntime().exec("getprop " + propName);
            input = new BufferedReader(new InputStreamReader(p.getInputStream()), 1024);
            line = input.readLine();
            input.close();
        } catch (IOException ex) {
            return null;
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return line;
    }

    /**
     * 获取屏幕宽度
     *
     * @return
     */
    public static int getScreenWidth(Context context) {
        return context.getResources().getDisplayMetrics().widthPixels;
    }

    /**
     * 获取屏幕高度
     *
     * @return
     */
    public static int getScreenHeight(Context context) {
        return context.getResources().getDisplayMetrics().heightPixels;
    }

    /**
     * 是否大于Android L
     */
    public static boolean isSupportL() {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP;
    }


    /**
     * 是否安装了指定app
     * @param context
     * @param packageName
     * @return
     */
    public static boolean isAppAvilible(Context context,String packageName) {
        final PackageManager packageManager = context.getPackageManager();// 获取packagemanager
        List<PackageInfo> pinfo = packageManager.getInstalledPackages(0);// 获取所有已安装程序的包信息
        if (pinfo != null) {
            for (int i = 0; i < pinfo.size(); i++) {
                String pn = pinfo.get(i).packageName;
                if (pn.equals(packageName)) {
                    return true;
                }
            }
        }
        return false;
    }


    /**
     * 通过包名打开app
     * @param context
     * @param packageName
     */
    public static void openApp (Context context,String packageName) {
        PackageManager packageManager = context.getPackageManager();
        Intent intent = new Intent();
        intent = packageManager.getLaunchIntentForPackage(packageName);
        if(intent == null){
            Toast.makeText(context, "未安装", Toast.LENGTH_LONG).show();
        } else {
            context.startActivity(intent);
        }
    }



}
