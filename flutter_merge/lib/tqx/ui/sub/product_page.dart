import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/common/colors.dart';
import 'package:flutter_merge/tqx/model/product_bean.dart';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:flutter_merge/tqx/net/http_client.dart';
import 'package:flutter_merge/tqx/ui/details_page.dart';

class ProductListPage extends StatefulWidget {

  final int index;

  ProductListPage({Key key, @required this.index}):super(key: key);

  @override
  _ProductListPageState createState() => new _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  HttpClient client = HttpClient();
  List<Goods> list;

  @override
  void initState() {
    super.initState();
    _getProductData();
  }

  /**
   * fetch data from network
   */
  _getProductData() {
    client.getProductList(cId: widget.index, page: 1,
        callback: (map) {
          setState(() {
            list = map['list'];
          });
          print('size: ${list.length}');
        },
        errorCb: (code, msg) {

        });
  }

  @override
  Widget build(BuildContext context) {
    return list == null || list.isEmpty ? Center(
//      child: Text('loading...'),
      child: CircularProgressIndicator(),
    ) : RefreshIndicator(
      child: ListView.builder(
        itemBuilder: _buildItem,
        itemCount: list.length,
      ),
      onRefresh: _pullRefresh,
    );
  }

  Future _pullRefresh() async {
    _getProductData();
  }

  Widget _buildItem(context, index) {
    Goods goods = list[index];
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return DetailsPage(goods: goods,);
        }));
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
//          图片
            Container(
              width: 100.0,
              height: 100.0,
//            child: Image.asset('images/dog.jpeg', fit: BoxFit.cover,),
              child: Image.network(goods.imgUrl),
            ),
//          标题
            Expanded(child: Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(goods.goodsName, style: TextStyle(fontSize: 15.0), maxLines: 2, overflow: TextOverflow.ellipsis,),
//                原价 和 销量 row
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text('原价 ¥${goods.goodsPrice}', style: TextStyle(fontSize: 13.0, color: Colorful.TEXT_GREY, decoration: TextDecoration.lineThrough),),
                        Text('销量${goods.saleCount}', style: TextStyle(fontSize: 13.0, color: Colorful.TEXT_GREY,),),
                      ],
                    ),
                  ),
//                立减 券后
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black, width: 1.0), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: Text('立减¥${goods.actMoney}', style: TextStyle(fontSize: 12.0, color: Colors.black,),),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                          decoration: BoxDecoration(color: Color(0xff1384ff), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: Text('券后¥${goods.lastPrice}', style: TextStyle(fontSize: 15.0, color: Colors.white),),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
          ],
        ), // 第一个 Row
      ),
    );
  }
}


