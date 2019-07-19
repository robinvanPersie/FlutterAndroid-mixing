
import 'package:flutter/material.dart';

///原始指针事件处理
class ListenerWidget extends StatefulWidget {
  @override
  _ListenerWidgetState createState() => new _ListenerWidgetState();
}

class _ListenerWidgetState extends State<ListenerWidget> {

  PointerEvent _event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        // deferChild 点在当前widget上有效
        // opaque 当前整个widget都有效，子widget外有效
        // translucent 透明区域有效，且会透过透明区域传递到下层的widget
        behavior: HitTestBehavior.translucent,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                color: Colors.blue,
                width: 300.0,
                height: 150.0,
                child: Text(_event?.toString()??"", style: TextStyle(color: Colors.white),),
              ),
              DecoratedBox(
                decoration: BoxDecoration(border: Border.all(width: 1.0)),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(Size(300.0, 150.0)),
                  child: Text('Box A'),
                ),
              ),
            ],
          ),
        ),
        // event里的offset是基于屏幕左上角
        onPointerDown: (event) => setState(() => _event = event),
        onPointerMove: (event) => setState(() => _event = event),
        onPointerUp: (event) => setState(() => _event = event),
      ),
    );
  }
}
