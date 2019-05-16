import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/db/data_base.dart';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:flutter_merge/tqx/common/colors.dart';

class FavoritePage extends StatefulWidget {

  @override
  _FavoritePageState createState() => new _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  MDatabase database = MDatabase();
  List<Goods> list;

  @override
  void initState() {
    super.initState();
    _getFavorites();
  }

  /**
   * 从db里获取收藏列表
   */
  _getFavorites() async {
    List<Map> result = await database.queryProduct();
    list = List();
    setState(() {
      result.forEach((map) {
        list.add(Goods.fromSql(map));
      });
    });
  }

  /**
   * 清空 二次确认弹窗
   */
  Widget _buildAlertDialog(context) {
    return AlertDialog(
      content: Text('是否删除所有收藏？'),
      contentTextStyle: TextStyle(fontSize: 15.0, color: Colors.black),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('取消'),
        ),
        MaterialButton(
          onPressed: () {
            setState(() {
              list.clear();
            });
            Navigator.of(context).pop();
          },
          child: Text('确定'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: Text('我的收藏'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              showDialog(
//               点击空白处 是否 dismiss
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return _buildAlertDialog(context);
                },
              );
            },
            child: Text('清空', style: TextStyle(color: Colorful.PRIMARY_BLUE),),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (list == null) {
      return Center(
        child: Text('loading...'),
      );
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
      itemCount: list.length,
      itemBuilder: _buildItem,
    );
  }

  Widget _buildItem(context, index) {
    Goods goods = list[index];
    return Container(
      padding: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 0,
            top: 0,
            height: 100.0,
            child: Image.network(goods.imgUrl, fit: BoxFit.cover,),
          ),
          Positioned(
            top: 110,
            left: 0,
            child: Text(goods.goodsName, maxLines: 2, overflow: TextOverflow.ellipsis,),
          ),
          Positioned(
            top: 130,
            child: Text('原价¥${goods.goodsPrice}', style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 13.0, color: Color(0xff666666),),),
          ),
          Positioned(
            top: 130,
            right: 0,
            child: Text('销量${goods.saleCount}', style: TextStyle(fontSize: 13.0, color: Color(0xff666666),),),
          ),
        ],
      ),
    );
  }
}
