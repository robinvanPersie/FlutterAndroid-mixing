import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/channel/channels.dart';

/// 与原生通信的页面，混合开发才有效

class NextPage extends StatefulWidget {

  @override
  _NextPageState createState() => new _NextPageState();
}

class _NextPageState extends State<NextPage> {

  StreamSubscription subscription;
  String text;

  Future<String> _toAndroidGetBatteryLevel() async {
      String batteryLevel;
      final int result = await Channels.batteryLevel;
      batteryLevel = 'level: $result.';
      print(batteryLevel);
      return batteryLevel;
  }

  @override
  void initState() {
      super.initState();
      text = 'I am next page';
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
            Text(text, style: TextStyle(fontSize: 30.0, color: Colors.black),),
            RaisedButton(
              onPressed: () {
                _toAndroidGetBatteryLevel().then((bl) {
                  setState(() {
                    text = 'level: $bl';
                  });
                });
              },
              child: Text('to android'),
            ),
          ],
        ),
      ),
    );
  }

}
