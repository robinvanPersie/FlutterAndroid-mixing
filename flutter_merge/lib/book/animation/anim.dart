import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

/// e.g:
///
/// 构建一个控制器：  AnimationController controller = AnimationController(
///                      duration: Duration(milliseconds: 500), vsync: this);
/// 构建一条曲线：   Animation curve = CurvedAnimation(parent: controller,
///                                               curve: Curves.easeOut);
/// 构建一个Tween:  Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);

class ScaleAnimPage extends StatefulWidget {
  @override
  _ScaleAnimPageState createState() => new _ScaleAnimPageState();
}

//需要继承TickerProvider，如果有多个AnimationController，则应该使用TickerProviderStateMixin
class _ScaleAnimPageState extends State<ScaleAnimPage> with SingleTickerProviderStateMixin {

  Animation<double> animation;
  AnimationController controller;

  Animation<double> anim2;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
        vsync: this,
    );
//    animation = Tween(begin: 0.0, end: 300.0).animate(controller)
    //使用弹性曲线
    animation = CurvedAnimation(parent: controller, curve: Curves.bounceIn);
    //图片宽高从0变到300
    animation = new Tween(begin: 0.0, end: 300.0).animate(animation)
    ..addListener(() {
      setState(() {
        print(animation.value);
      });
    });

    anim2 = Tween(begin: 0.0, end: 300.0).animate(controller);
    anim2.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: 'scale Tween',
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: <Widget>[
              Image.asset('images/3.0x/ic_banner_first.png', width: animation.value),
              _AnimatedImage(anim: anim2,),
              // 动画构建范围缩小至 做动画本身的widget
              AnimatedBuilder(
                animation: anim2,
                child: Image.asset('images/3.0x/ic_banner_first.png', width: anim2.value,),
                builder: (ctx, child) { // 只重新调用这个build
                  return child;
                },
              ),
              FlatButton(
                onPressed: () {
                  controller.reset();
                  controller.forward();
                },
                child: Text('anim forward'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 动画和widget分离
class _AnimatedImage extends AnimatedWidget {

  _AnimatedImage({Key key, Animation<double> anim}):
      super(key: key, listenable: anim);

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Center(
      child: Image.asset('images/3.0x/ic_banner_second.png', width: animation.value,),
    );
  }
}
