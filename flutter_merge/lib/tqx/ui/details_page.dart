import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/channel/taobao_method.dart';
import 'package:flutter_merge/tqx/common/colors.dart';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:flutter_merge/tqx/utils/date_format.dart';
import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

/**
 * 优惠券详情页
 */
class DetailsPage extends StatefulWidget {

  final Goods goods;

  DetailsPage({@required Goods goods})
      : goods = goods;

  @override
  _DetailsPageState createState() => new _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: '商品详情',
      actions: <Widget>[
        IconButton(
          onPressed: (){
            setState(() {
              widget.goods.isFavorite = !widget.goods.isFavorite;
            });
          },
          icon: widget.goods.isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
        ),
      ],
      body: CustomScrollView(
        slivers: <Widget>[
          // 领券
          SliverToBoxAdapter(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 140.0,
              color: Color(0xffdddddd),
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(8.0))),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(8.0), bottomLeft: Radius.circular(8.0))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('¥ ${widget.goods.actMoney}', style: TextStyle(fontSize: 18.0, color: Colors.redAccent),),
                            Text('使用期限', style: TextStyle(fontSize: 13.0, color: Colorful.TEXT_SECONDARY),),
                            Text('${DateUtils.date2String(DateUtils.string2Date(widget.goods.beginDate))}-${DateUtils.date2String(DateUtils.string2Date(widget.goods.endDate))}',
                              style: TextStyle(fontSize: 13.0, color: Colorful.TEXT_SECONDARY),),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(color: Colorful.PRIMARY_BLUE, borderRadius: BorderRadius.only(topRight: Radius.circular(8.0), bottomRight: Radius.circular(8.0))),
                        child: MaterialButton(
                          onPressed: () {
                            //todo: open taobao app
                            TaoBaoMethod.openTaoBaoApp(widget.goods.actLink);
                          },
                          child: Center(
                            child: Text('立即领券', style: TextStyle(fontSize: 18.0, color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 商品
          SliverToBoxAdapter(
            child: Container(
              height: 110.0,
              padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 90.0,
                    height: 90.0,
                    child: Image.network(widget.goods.imgUrl, fit: BoxFit.cover,),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.goods.goodsName, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15.0, color: Colors.black),),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('原价¥${widget.goods.goodsPrice}', style: TextStyle(decoration: TextDecoration.lineThrough, fontSize: 13.0, color: Colorful.TEXT_GREY),),
                              Text('销量${widget.goods.saleCount}', style: TextStyle(fontSize: 13.0, color: Colorful.TEXT_GREY),),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 10.0),
                                padding: EdgeInsets.fromLTRB(3.0, 2.0, 3.0, 2.0),
                                decoration: BoxDecoration(color: Colorful.PRIMARY_BLUE, borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                child: Text('用券后', style: TextStyle(color: Colors.white),),
                              ),
                              Text('¥${widget.goods.lastPrice}', style: TextStyle(color: Colors.redAccent),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 更多推荐
          SliverToBoxAdapter(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Divider(),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text('更多推荐', style: TextStyle(fontSize: 16.0, color: Colorful.PRIMARY_BLUE),),
                ),
              ],
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 70.0,
            delegate: SliverChildBuilderDelegate(
                _buildItem,
                childCount: 5),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(context, index) {
    return Container(
      height: 70.0,
      decoration: BoxDecoration(border: Border.all()),
      child: Center(
        child: Text('item: $index', style: TextStyle(fontSize: 16.0),),
      ),
    );
  }
}
