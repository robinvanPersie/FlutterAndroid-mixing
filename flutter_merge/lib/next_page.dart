import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/channel/channels.dart';

class NextPage extends StatefulWidget {

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {

  StreamSubscription subscription;

  Future<void> _toAndroidGetBatteryLevel() async {
      String batteryLevel;
      final int result = await Channels.batteryLevel;
      batteryLevel = 'level: $result.';
      print(batteryLevel);
  }

  @override
  void initState() {
      super.initState();
      subscription = Channels.receiver('next_page.dart init()').listen(_onEvent, onError: _onError);
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
