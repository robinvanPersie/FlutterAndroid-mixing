//import 'package:json_annotation/json_annotation.dart';

part 'product_bean.g.dart';

/**
 * json_serialable 框架 ?????????
 */
//@JsonSerializable()
class ListProduct {

  ListProduct();

//  @JsonKey(name: 'error')
  int code;
  String msg;
  List<Product> data;

  factory ListProduct.fromJson(Map<String, dynamic> json) => _$ListProductFromJson(json);

  Map<String, dynamic> toJson() => _$ListProductToJson(this);
}

//@JsonSerializable()
class Product {

  Product();

  int ID; // 商品id
  var GoodsId; //商品淘宝id
  String GoodsName; // 标题
  String GoodsClass; // 分类：中文
  String GoodsLink; // 商品链接
  String ActLink; // 优惠券链接
  String ImgUrl; // 广告图地址
  int ActMoney; //优惠券价格
  double GoodsPrice;  //原价
  double LastPrice; // 现价
  String BeginDate; // 开始时间
  String EndDate; // 结束时间
  int SaleCount; // 总销量
  int TKMoneyRate; // 佣金比例
  String TjRemark; // 文案
//  @JsonKey(name: 'Coupon_Count')
  int CouponCount; // 优惠券数量
//  @JsonKey(name: 'Coupon_SaleCount')
  int CouponSaleCount; // 优惠券剩余
  int ly; // 1 天猫，2 淘宝
  String MarketImage; //营销图（未提供）
  int ActivityType; //活动类型 0 无活动， 1 淘抢购， 2 聚划算
  int OrderCount; // 爆单指数
  int TowHourCount; // 两小时销量
  int AllDayCount; // 全天销量
  String SellerId; // 卖家id
  int CommssionType; // 佣金类型 0 通用， 1 定向， 2 营销

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}