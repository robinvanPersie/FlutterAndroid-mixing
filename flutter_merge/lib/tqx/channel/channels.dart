import 'package:flutter/services.dart';

class Channels {

  static const MethodChannel _methodChannel =
      MethodChannel('com.antimage.af/to_android');

  /**
   * 获取电池电量
   */
  static Future<int> get batteryLevel async {
    return await _methodChannel.invokeMethod('getBatteryLevel');
  }

  /**
   * 调用原生跳转其他App
   */
  static Future<String> openApp([dynamic arguments]) async {
    return await _methodChannel.invokeMethod('openApplication', arguments);
  }

  // ************************************************

  static const EventChannel eventChannel =
      EventChannel('com.antimage.af/to_flutter');

  static Stream<dynamic> receiver([ dynamic arguments ]) {
    return eventChannel.receiveBroadcastStream(arguments);
  }
}