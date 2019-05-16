import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/net/http_client.dart';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_merge/tqx/widget/swiper/without_control.dart';
import 'package:flutter_merge/tqx/db/data_base.dart';

class RecommendPage extends StatefulWidget {

  @override
  _RecommendPageState createState() => new _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {

  HttpClient client = HttpClient();
  MDatabase database = MDatabase();
  List<Goods> list;
  List<Goods> tomorrows;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getRecommend();
    _getTomorrows();
  }

  /**
   * 推荐列表
   */
  _getRecommend() {
    client.getRecommendList(4, (result) {
      setState(() {
        list = result['list'];
      });
      print('recommend size: ${list.length}');
    });
  }

  /**
   * 明日预告
   */
  _getTomorrows() {
    client.getTomorrowProduct(2, (result) {
      setState(() {
        tomorrows = result['list'];
        print('tomorrow size: ${tomorrows.length}');
        database.insertProduct(tomorrows[0]);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
//          9.9 和 排行榜
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(child: Column(
                    children: <Widget>[
                      Icon(Icons.email),
                      Text('9.9包邮', style: TextStyle(fontSize: 16.0, color: Colors.black),),
                      Text('每日白菜价', style: TextStyle(fontSize: 13.0, color: Colors.black),),
                    ],
                  ),),
                  Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    width: 1.0,
                    height: 80.0,
                    color: Color(0xffcccccc),
                  ),
                  Expanded(child: Column(
                    children: <Widget>[
                      Icon(Icons.list),
                      Text('排行榜', style: TextStyle(fontSize: 16.0, color: Colors.black),),
                      Text('热款爆卖', style: TextStyle(fontSize: 13.0, color: Colors.black),),
                    ],
                  ),),

                ],
              ),
            ),
          ),
//          轮播文字
          SliverToBoxAdapter(
            child: Container(
              height: 40.0,
              color: Color(0xfff1f2f2),
              child: tomorrows == null ? null  : Row(
                children: <Widget>[
                  Icon(Icons.notifications),
                  Container(child: Text('预告'), margin: EdgeInsets.only(left: 5.0, right: 10.0),),
                  Expanded(
                    child: Swiper(
                      scrollDirection: Axis.vertical,
                      itemCount: tomorrows.length,
                      itemBuilder: (context, index) {
                        return Align(
                          alignment: FractionalOffset.centerLeft,
                          child: Text('大家都在搜：${tomorrows[index].goodsName}'),
                        );
                      },
                      autoplayDelay: 2500,
                      duration: 1500,
                      autoplay: true,
                      control: SwipeWithoutControl(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      body: list == null ? _loading()
          : ListView.builder(
          itemCount: list.length,
          itemBuilder: _buildItem),
    );
  }

  Widget _loading() {
    return Center(child: CircularProgressIndicator(),);
  }

  Widget _buildItem(context, index) {
    Goods goods = list[index];
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: <Widget>[
          Container(
            width: 100.0,
            height: 100.0,
            child: Image.network(goods.imgUrl),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(goods.goodsName, maxLines: 2, overflow: TextOverflow.ellipsis,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('原价¥${goods.goodsPrice}', style: TextStyle(fontSize: 13.0, color: Color(0xff666666), decoration: TextDecoration.lineThrough),),
                      Text('销量${goods.saleCount}', style: TextStyle(fontSize: 13.0, color: Color(0xff666666),),)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                            decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Text('立减¥${goods.actMoney}', style: TextStyle(fontSize: 12.0, color: Colors.black,),),
                          ),
                          Text('券后¥${goods.lastPrice}', style: TextStyle(color: Colors.black),),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
                        decoration: BoxDecoration(color: Color(0xff1384ff), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Text('券后¥${goods.lastPrice}', style: TextStyle(fontSize: 15.0, color: Colors.white),),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ), // expanded
        ],
      ),
    );
  }
}