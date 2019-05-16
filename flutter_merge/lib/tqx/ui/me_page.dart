import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/ui/my_favorite.dart';

class MePage extends StatelessWidget {

  final mainColor = Color(0xff1384ff);

  List<_Item> list = [
    _Item(title: '我的收藏', icon: Icons.favorite),
    _Item(isDivider: true),
    _Item(title: '我的足迹', icon: Icons.forward_5),
    _Item(isDivider: true),
    _Item(title: '领券指南', icon: Icons.directions),
    _Item(isSpace: true),
    _Item(title: '推荐好友', icon: Icons.more_horiz),
    _Item(isDivider: true),
    _Item(title: '好评一下', icon: Icons.wallpaper),
    _Item(isSpace: true),
    _Item(title: '关于淘气星', icon: Icons.atm),
  ];


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        _Item item = list[index];
        return GestureDetector(
          onTap: () {
            _onItemClick(context, item, index);
          },
          child: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            width: size.width,
            height: item.space ? 10.0 : item.divider ? 1.0 : 48.0,
            color: Colors.white,
            child: item.title == null ? item.space ? _buildSpace() : _buildDivider() :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(item.icon, color: mainColor,),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(item.title, style: TextStyle(fontSize: 15.0, color: Colors.black),),
                    ),
                  ],
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        );
      },
    );
  }

  // 分割线
  Widget _buildDivider() {
    return Container(
      height: 10.0,
      margin: EdgeInsets.only(left: 20.0, right: 20.0),
      color: Color(0xfffafafa),
      child: Divider(),
    );
  }

  // 间隔
  Widget _buildSpace() {
    return Container(
      height: 10.0,
      color: Color(0xfff5f5f5),
      child: Text(''),
    );
  }

  // item click
  _onItemClick(BuildContext context, _Item item, int index) {
    switch (index) {
      case 0:
        if (item.space || item.divider) return;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return FavoritePage();
        }));
        break;
    }
  }
}

class _Item {

  final String title;
  final IconData icon;
  final bool space;
  final bool divider;

  _Item({this.title, this.icon, bool isSpace, bool isDivider})
      : space = isSpace == null ? false : isSpace,
        divider = isDivider == null ? false : isDivider;
}
