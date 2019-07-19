import 'package:flutter/material.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

/// 手势识别--拖动
class DragGesture extends StatefulWidget {

  @override
  _DragGestureState createState() => new _DragGestureState();
}

class _DragGestureState extends State<DragGesture> with SingleTickerProviderStateMixin {

  double _top = 0.0;
  double _left = 0.0;
  double _screenWidth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey circleAvatarKey = GlobalKey();
    _screenWidth = MediaQuery.of(context).size.width;

    return CustomizeScaffold(
      title: 'drag gesture',
      floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          child: Text('scale'),
      ),
      body: Stack(
        children: <Widget>[

          // 上下左右拖动
          Positioned(
            left: _left,
            top: _top,
            child: GestureDetector(
              child: CircleAvatar(
                key: circleAvatarKey,
                child: Text('A'),
              ),
              onPanDown: (DragDownDetails e) {
                print("用户手指按下：${e.globalPosition}");
              },
              //手指滑动时会触发此回调
              onPanUpdate: (DragUpdateDetails e) {
                setState(() {
                  _left += e.delta.dx;
                  _top += e.delta.dy;
                  // 左右 不超出屏幕, 上下同理
                  _left = _left < 0.0 ? 0.0 : _left >
                      _screenWidth - circleAvatarKey.currentContext.size.width ?
                  _screenWidth - circleAvatarKey.currentContext.size.width : _left;
                });
              },
              onPanEnd: (DragEndDetails e){
                //打印滑动结束时在x、y轴上的速度
                print('结束时滑动速度: ${e.velocity}');
              },
            ),
          ),
          // 上下拖动
          Positioned(
            top: _top,
            child: GestureDetector(
              child: CircleAvatar(
                child: Text('B'),
                backgroundColor: Colors.red,
              ),
              onVerticalDragUpdate: (DragUpdateDetails e) {
                setState(() {
                  _top += e.delta.dy;
                });
              },
            ),
          ),
          // 左右拖动
          Positioned(
            left: _left,
            child: GestureDetector(
              child: CircleAvatar(
                child: Text('C'),
                backgroundColor: Colors.black,
              ),
              onHorizontalDragUpdate: (DragUpdateDetails e) {
                setState(() {
                  _left += e.delta.dx;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
