
# 这是一个flutter和Android混合开发的project
   
## 混合步骤简介：
1. 创建native工程
2. 以module的形式创建flutter工程
3. 将flutter工程导入至native工程中，使flutter工程作为一个module存在与native工程中

## 混合参考资料： [flutter/fultter/wiki](https://github.com/flutter/flutter/wiki/Add-Flutter-to-existing-apps)

* Q: 为什么不创建一个flutter工程，然后直接在其根目录下的Android目录进行开发？
- A: 查了一些资料，没有找到这种混合方式，似乎直接新建的flutter工程是纯flutter的，Android目录和ios目录里都是存放的打包相关的配置，如所说有误，欢迎指正


## 介绍
### Android项目
#### 一.使用了2种方式加载flutter页面
1. 第一种是在activity中创建一个flutterView, 然后传递给setContentView()方法
```
FlutterView fv = Flutter.createView(this, getLifecycle(), "route1");
ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(-1, -1);
setContentView(fv, params);  
```
Flutter.createView()会创建一个系统自带的通信通道，第三个参数“route1”会传递给lib/main.dart文件中，通过以下方式获取:
```
import 'dart:ui'

String _getRoute() {
  return window.defaultRoute;
}
```

2. 第二种是直接继承FlutterActivity，不需要额外编写代码，但是父类对theme做了设置，会导致一些ui上的问题，需要手动设置回来。

- **另外**：实际开发中我们会有自己的BaseActivity需要继承，所以我的第二种方式并没有继承FlutterActivity,但是原理一样的，具体查看[CustomizeActivity](https://github.com/robinvanPersie/FlutterAndroid-mixing/blob/master/androidflutter/app/src/main/java/com/antimage/af/act/CustomizeActivity.java)

#### 二.实现了与flutter的简单双向通信工具类，目前看来类似于Intent去匹配action的机制
- 通信参考资料[flutter/examples/platform_channel](https://github.com/flutter/flutter/tree/master/examples/platform_channel)

### flutter项目
#### 一. 使用纯flutter写了一个简单的Material Design风格的app，将Android下MD风格的widget在flutter中找到对应，顺便熟悉下flutter其他基础widget.
1. 使用google推荐dart网络请求库Dio，[Dio网络请求框架](https://github.com/flutterchina/dio)，请求网络数据展示成列表
2. 使用sqflite实现数据持久化存储 [sqflite数据库插件](https://github.com/tekartik/sqflite)
**项目在lib/tqx/目录下**

#### 二. 进行配置与Android的简单双向通信.

## Android加载的具体文件
 Android加载flutter页面时，会默认搜索lib目录下的main.dart文件进行加载，搜索不到则会报错并停止Gradle building。


