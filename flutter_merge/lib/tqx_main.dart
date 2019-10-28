import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/ui/home_page.dart';
import 'package:flutter_merge/tqx/ui/recommend_page.dart';
import 'package:flutter_merge/tqx/ui/me_page.dart';
import 'package:flutter_merge/next_page.dart';

void main() => runApp(App());

class App extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'tqx app',
      theme: ThemeData(primaryColor: Color(0xffffffff)),
      home: TQXScaffold(),
    );
  }
}

/// main.dart里直接router到此widget可以跳转过来

class TQXScaffold extends StatefulWidget {

  @override
  _TQXScaffoldState createState() => new _TQXScaffoldState();
}

class _TQXScaffoldState extends State<TQXScaffold> {

  String _title;
  final _pages = [HomePage(), RecommendPage(), MePage()];
  int _index = 0;


  _changeBodyPageAndTitle(String title, int index) {
    setState(() {
      _title = title;
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(_title == null ? '商城' : _title),
          elevation: 0.2,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return NextPage();
              }));
            },
            child: Text('与原生通信'),
          ),
        ],
      ),
//      bottomNavigationBar: MBottomNavigation(_changeBodyPageAndTitle),
      bottomNavigationBar: _buildBottomNavigation(),
      body: _pages.elementAt(_index),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      onTap: (index) {
        switch (index) {
          case 0:
            _changeBodyPageAndTitle('商城', index);
            break;
          case 1:
            _changeBodyPageAndTitle('推荐', index);
            break;
          case 2:
            _changeBodyPageAndTitle('我的', index);
            break;
        }
      },
        type: BottomNavigationBarType.fixed,
        fixedColor: Color(0xff1384ff),
      currentIndex: _index,
      items: buildBottomItem(),
    );
  }

  List<BottomNavigationBarItem> buildBottomItem() {
    Color activeColor = Color(0xff1384ff);
    List<BottomNavigationBarItem> list = List();
    list..add(BottomNavigationBarItem(title: Text('商城', style: TextStyle(height: 1, fontSize: 10,),), icon: Icon(Icons.store, color: Colors.grey,), activeIcon: Icon(Icons.store, color: activeColor,)))
      ..add(BottomNavigationBarItem(title: Text('推荐', style: TextStyle(height: 1, fontSize: 10),), icon: Icon(Icons.more_horiz), activeIcon: Icon(Icons.more_horiz, color: activeColor,)))
      ..add(BottomNavigationBarItem(title: Text('我的', style: TextStyle(height: 1, fontSize: 10),), icon: Icon(Icons.person), activeIcon: Icon(Icons.person, color: activeColor,)));
    return list;
  }
}



