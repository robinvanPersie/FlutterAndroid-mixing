import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NextPage extends StatefulWidget {

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {

  static const MethodChannel methodChannel = MethodChannel('com.antimage.af/to_android');
  static const EventChannel eventChannel = EventChannel('com.antimage.af/to_flutter');
  StreamSubscription subscription;

  Future<void> _toAndroidGetBatteryLevel() async {
      String batteryLevel;
      final int result = await methodChannel.invokeMethod('getBatteryLevel');
      batteryLevel = 'level: $result.';
      print(batteryLevel);
  }

  @override
  void initState() {
      super.initState();
      subscription = eventChannel.receiveBroadcastStream('next_page.dart init()').listen(_onEvent, onError: _onError);
  }

  void _onEvent(Object event) {
      print('onEvent: $event');
      print(subscription == null);
  }

  void _onError(Object error) {
      print('onError: $error');
  }

  @override
  void dispose() {
      if (subscription != null) {
          subscription.cancel();
      }
      print('next page dispose');
      super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back),
            onPressed: () {
             Navigator.of(context).pop();
            }),
      ),
      body: Center(
        child: Column(
  children: <Widget>[
  Text('I am next page', style: TextStyle(fontSize: 30.0, color: Colors.black),),
  RaisedButton(
  onPressed: (){
    _toAndroidGetBatteryLevel();
  },
  child: Text('to android'),
  ),
  ],
  ),
      ),
    );
  }

}
