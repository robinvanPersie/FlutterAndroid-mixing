import 'package:flutter_merge/book/event/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_merge/common/style/text_style.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

var eventName = 'test_event';

class EventRegisterPage extends StatefulWidget {

  @override
  _EventRegisterPageState createState() => new _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {

  final EventBus bus = EventBus();
  var text = 'may be change';
  EventCallback _cb;

  @override
  void initState() {
    super.initState();
    _cb = (arg) {
      print('receiver from event bus: $arg');
      setState(() {
        text = arg;
      });
    };
    bus.register(eventName, _cb);
  }

  @override
  void dispose() {
    bus.unregister(eventName, _cb);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomizeScaffold(
      title: 'event register',
      body: Center(
        child: Column(
          children: <Widget>[
            Text(text, style: TextStyles.sizeStyle(24.0),),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return EventPostPage();
                }));
              },
              child: Text('next page'),
            ),
          ],
        )
      ),
    );
  }
}

class EventPostPage extends StatelessWidget {

  final EventBus bus = EventBus();

  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: 'post page',
      body: RaisedButton(
          onPressed: () {
            bus.post(eventName, 'i am a msg by post');
          },
        child: Text('post a event'),
      ),
    );
  }
}
