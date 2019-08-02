import 'package:flutter/material.dart';
import 'package:flutter_merge/common/route_map.dart';
import 'package:flutter_merge/common/style/text_style.dart';

void main() {
//  FlutterError.onError = (FlutterErrorDetails details) {
//     // todo
//  };
  runApp(new App());
}

class App extends StatelessWidget {

  DateTime _lastPress;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'router',
      theme: ThemeData(primaryColor: Color(0xffffffff)),
      home: Scaffold(
        appBar: AppBar(
          title: Text('RouterPage'),
        ),
        body: WillPopScope( // 防止意外退出
            child: RouterBody(),
            onWillPop: () async {
              if (_lastPress == null || DateTime.now().difference(_lastPress) > Duration(seconds: 1)) {
                _lastPress = DateTime.now();
                print("return false");
                return false;
              } else {
                return true;
              }
            },
        ),
      ),
      routes: RouteManager.register(),
    );
  }
}


class RouterBody extends StatefulWidget {
  @override
  _RouterBodyState createState() => new _RouterBodyState();
}

class _RouterBodyState extends State<RouterBody> {

  var items = ['淘气星球App', 'PointerEvent原始指针事件处理', 'Drag拖动手势',
    'Scale缩放手势', 'EventBus事件总线', '通知冒泡', 'scale动画', 'Hero',
  '交错动画'];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: _itemBuilder,
      itemCount: items.length,
      separatorBuilder: (ctx, index) => Divider(height: 1.0, color: Colors.grey,),
    );
  }

  Widget _itemBuilder(ctx, index) {
    return InkWell(
      onTap: () {
        String routeName = RouteManager.routePageName(index);
        if (routeName == null || routeName.length == 0) return;
        Navigator.pushNamed(ctx, routeName);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(items[index], style: TextStyles.sizeStyle(16.0),),
      ),
      highlightColor: Color(0xfff5f5f5),
    );
  }
}
