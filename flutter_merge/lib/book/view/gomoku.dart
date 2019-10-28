import 'dart:math';

import 'package:flutter/material.dart';

/// 五子棋盘
/// e.g:
///
/// CusTomPaint({
///   this.painter, 背景画笔，显示在子节点后面
///   this.foregroundPainter, 前景画笔，显示在子节点前面
///   this.size = Size.zero, child为null时，表示默认绘制区域大小，有child时忽略此参数
///   this.isComplex = false, 是否复杂绘制，如果是，会启用缓存策略减少重复渲染的开销
///   this.willChange = false, 和isComplex配合使用，当启用缓存时，该属性代表在下一帧中绘制是否会改变
/// })
///
/// attention: 如果CustomPaint有子节点，为了避免子节点不必要的重绘并提高性能，
/// 通常情况下都会将子节点包裹在RepaintBoundary Widget中，
/// 这样会在绘制时创建一个新的绘制层（Layer），其子Widget将在新的Layer上绘制，
/// 而父Widget将在原来Layer上绘制，也就是说RepaintBoundary 子Widget的绘制将独立于父Widget的绘制，
/// RepaintBoundary会隔离其子节点和CustomPaint本身的绘制边界。示例如下：
/// e.g:
///   CustomPaint(
///     size: Size(300, 300),
///     painter: MPainter(),
///     child: RepaintBoundary(
///       child: ...
///     )
///   )
///
class GomokuWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: Size(300.0, 300.0),
        painter: _MPainter(),
        child: RepaintBoundary(
          child: CustomPaint(
            size: Size(300.0, 300.0),
            painter: _ChildPainter(),
          ),
        ),
      ),
    );
  }
}

/// 棋子独立绘制
class _ChildPainter extends CustomPainter {

  final bool change;

  _ChildPainter({this.change});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width / 15;
    double h = size.height / 15;

    var paint = Paint();
    paint..style = PaintingStyle.fill
      ..color = Colors.black;
    canvas.drawCircle(Offset((size.width - w) / 2, (size.height - h) / 2), min(w / 2, h / 2), paint);

    // 画一个白子
    paint..color = Colors.white;
    canvas.drawCircle(Offset((size.width + w) / 2, (size.height - h) / 2), min(w / 2, h / 2), paint);
  }

  @override
  bool shouldRepaint(_ChildPainter oldDelegate) {
    return oldDelegate.change != this.change;
  }
}

/// 棋盘独立绘制
/// [_ChildPainter] 独立绘制棋子
class _MPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width / 15;
    double h = size.height / 15;

    //画棋盘背景
    var paint = Paint();
    paint..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Color(0x77cdb175);
    canvas.drawRect(Offset.zero & size, paint);

    //画棋盘网格
    paint..style = PaintingStyle.stroke
    ..color = Colors.black87
    ..strokeWidth = 1.0;

    for (int i = 0; i <= 15; ++i) {
      double dy = h * i;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }

    for (int i = 0; i <= 15; ++i) {
      double dx = w * i;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

//    // 画一个黑子
//    paint..style = PaintingStyle.fill
//    ..color = Colors.black;
//    canvas.drawCircle(Offset((size.width - w) / 2, (size.height - h) / 2), min(w / 2, h / 2), paint);
//
//    // 画一个白子
//    paint..color = Colors.white;
//    canvas.drawCircle(Offset((size.width + w) / 2, (size.height - h) / 2), min(w / 2, h / 2), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}