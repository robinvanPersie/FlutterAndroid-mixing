import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

class ScaleGesture extends StatefulWidget {
  @override
  _ScaleGestureState createState() => new _ScaleGestureState();
}

class _ScaleGestureState extends State<ScaleGesture> {

  double _width = 200.0;
  bool _toggle = false;
  TapGestureRecognizer _tapGestureRecognizer = TapGestureRecognizer();

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return CustomizeScaffold(
      title: 'scale gesture',
      body: ListView(
        children: <Widget>[
          _scale(),
          _gestureRecognizer(),
        ],
      ),
    );
  }

  Widget _scale() {
    return Center(
      child: GestureDetector(
        child: Image.asset('images/3.0x/ic_banner_second.png', width: _width,),
        onScaleUpdate: (ScaleUpdateDetails e) {
          setState(() {
            _width = 200 * e.scale.clamp(0.8, 5.0);
          });
        },
      ),
    );
  }

  Widget _gestureRecognizer() {
    return Center(
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'fist TextSpan'
            ),
            TextSpan(
              text: 'click me change color',
              style: TextStyle(fontSize: 20.0,color: _toggle ? Colors.blue : Colors.red),
              recognizer: _tapGestureRecognizer..onTap = () {
                setState(() {
                  _toggle = !_toggle;
                });
              },
            ),
            TextSpan(text: 'last TextSpan'),
          ],
        ),
      ),
    );
  }
}
