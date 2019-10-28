import 'package:flutter/material.dart';
import 'package:flutter_merge/book/view/gomoku.dart';
import 'package:flutter_merge/book/view/turn_box.dart';
import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

import 'circle_gradient_progress.dart';
import 'gradient_button.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

class CustomWidgets extends StatefulWidget {
  @override
  _CustomWidgetsState createState() => new _CustomWidgetsState();
}

class _CustomWidgetsState extends State<CustomWidgets> {

  double _turns = .0;

  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: 'custom widgets',
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.grey[400],
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                alignment: Alignment.centerLeft,
                child: Text('渐变按钮', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              GradientButton(
                colors: [Colors.orange, Colors.red],
                height: 50.0,
                child: Text('submit -- tap me'),
                onTap: _onRotationTap,
              ),
              GradientButton(
                colors: [Colors.lightGreen, Colors.green[700]],
                child: Text('green submit'),
                height: 50.0,
              ),
              Container(
                color: Colors.grey[400],
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                alignment: Alignment.centerLeft,
                child: Text('旋转过渡动画', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              TurnBox(
                turns: _turns,
                speed: 400,
                child: Icon(Icons.refresh, size: 50.0,),
              ),
              Container(
                color: Colors.grey[400],
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                alignment: Alignment.centerLeft,
                child: Text('五子棋盘', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              GomokuWidget(),
              Container(
                color: Colors.grey[400],
                padding: EdgeInsets.only(top: 7.0, bottom: 7.0),
                alignment: Alignment.centerLeft,
                child: Text('圆形渐变进度条', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
              ),
              CircleGradientProgress(
                  radius: 30.0,
                  colors: [Colors.lightBlue, Colors.redAccent],
                  stokeWidth: 5.0,
                value: 0.8,
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///点击旋转 TurnBox
  _onRotationTap() {
    setState(() {
      _turns -= .2;
    });
  }
}