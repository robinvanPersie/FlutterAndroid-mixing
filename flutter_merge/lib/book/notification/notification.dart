import 'package:flutter/material.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';
/// 通知 冒泡
class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => new _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  String _msg = '';

  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: '通知冒泡',
      body: Column(
        children: <Widget>[
          // 第一个child
          NotificationListener(
            onNotification: (n) {
              switch (n.runtimeType) {
                case ScrollStartNotification: print('begin scroll'); break;
                case ScrollUpdateNotification: print('scrolling'); break;
                case ScrollEndNotification: print('end scroll'); break;
                case OverscrollNotification: print('scroll to limit'); break;
              }
            },
            child: ListView.builder(
              shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(title: Text('item: $index'),),
              itemCount: 100,
            ),
          ),
          // 第二个child
          NotificationListener<_CustomNotification>(
            onNotification: (n) {
              setState(() {
                _msg += n.msg + '  ';
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Builder(
                  builder: (ctx) {
                    return RaisedButton(
                      onPressed: () => _CustomNotification("hi").dispatch(ctx),
                      child: Text('send CustomNotification'),
                    );
                  },
                ),
                Text(_msg),
              ],
            ),
          ),
        ].map((widget) => Expanded(child: widget,)).toList(),
      ),
    );
  }
}

class _CustomNotification extends Notification {

  final String msg;

  _CustomNotification(this.msg);

}
