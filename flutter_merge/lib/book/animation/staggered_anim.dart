import 'package:flutter/material.dart';

/// animation declare
/// 有问题：黑屏...

class _StaggerAnim extends StatelessWidget {

  _StaggerAnim({Key key, this.controller}): super(key: key) {

    height = Tween<double>(
      begin: 0.0, end: 30.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.6, curve: Curves.ease),
      ),
    );

    color = ColorTween(
        begin: Colors.green, end: Colors.red
    ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Interval(0.0, 0.6, curve: Curves.ease),
        ),
    );

    padding = Tween<EdgeInsets>(
      begin: EdgeInsets.only(left: 0.0),
      end: EdgeInsets.only(left: 100.0),
    ).animate(
       CurvedAnimation(
         parent: controller,
         curve: Interval(0.6, 1.0, curve: Curves.ease),
       ),
    );
  }

  final Animation<double> controller;
  Animation<double> height;
  Animation<EdgeInsets> padding;
  Animation<Color> color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }

  Widget _buildAnimation(context, child) {
    return Container(
       alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: 50.0,
        height: height.value,
      ),
    );
  }
}


class StaggerPage extends StatefulWidget {

  @override
  _StaggerPageState createState() => new _StaggerPageState();
}

class _StaggerPageState extends State<StaggerPage> with TickerProviderStateMixin {

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
      duration: Duration(microseconds: 5000),
    );
  }

  Future<Null> _playAnimation() async {
    try {
      await _controller.forward().orCancel;

      await _controller.reverse().orCancel;
    } on TickerCanceled {
       print('the animation got canceled, probably because we were disposed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _playAnimation(),
      child: Center(
        child: Container(
          width: 300.0,
          height: 300.0,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            border: Border.all(color: Colors.black.withOpacity(0.5)),
          ),
          child: _StaggerAnim(controller: _controller,),
        ),
      ),
    );
  }
}
