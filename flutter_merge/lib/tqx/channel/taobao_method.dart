import 'package:flutter_merge/tqx/channel/channels.dart';

class TaoBaoMethod {

  static Future<String> openTaoBaoApp(String actLink) async {
    return await Channels.openApp({'package': 'taobao', 'actLink': actLink},);
  }
}