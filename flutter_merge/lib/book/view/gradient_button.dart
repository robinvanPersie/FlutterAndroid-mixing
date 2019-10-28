import 'package:flutter/material.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

class GradientButton extends StatelessWidget {

  final List<Color> colors;
  final double width;
  final double height;
  final Widget child;
  final GestureTapCallback onTap;

  GradientButton({this.colors, this.width, this.height, this.onTap, @required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
//          splashColor: colors.last, // 波纹的颜色
//        highlightColor: Colors.blue, // 按压的颜色
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: width, height: height),
            child: Center(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

