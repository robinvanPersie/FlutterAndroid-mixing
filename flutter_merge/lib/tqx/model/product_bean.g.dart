// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListProduct _$ListProductFromJson(Map<String, dynamic> json) {
  return ListProduct()
    ..code = json['error'] as int
    ..msg = json['msg'] as String
    ..data = (json['data'] as List)
        ?.map((e) =>
            e == null ? null : Product.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ListProductToJson(ListProduct instance) =>
    <String, dynamic>{
      'error': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..ID = json['ID'] as int
    ..GoodsId = json['GoodsId']
    ..GoodsName = json['GoodsName'] as String
    ..GoodsClass = json['GoodsClass'] as String
    ..GoodsLink = json['GoodsLink'] as String
    ..ActLink = json['ActLink'] as String
    ..ImgUrl = json['ImgUrl'] as String
    ..ActMoney = json['ActMoney'] as int
    ..GoodsPrice = (json['GoodsPrice'] as num)?.toDouble()
    ..LastPrice = (json['LastPrice'] as num)?.toDouble()
    ..BeginDate = json['BeginDate'] as String
    ..EndDate = json['EndDate'] as String
    ..SaleCount = json['SaleCount'] as int
    ..TKMoneyRate = json['TKMoneyRate'] as int
    ..TjRemark = json['TjRemark'] as String
    ..CouponCount = json['Coupon_Count'] as int
    ..CouponSaleCount = json['Coupon_SaleCount'] as int
    ..ly = json['ly'] as int
    ..MarketImage = json['MarketImage'] as String
    ..ActivityType = json['ActivityType'] as int
    ..OrderCount = json['OrderCount'] as int
    ..TowHourCount = json['TowHourCount'] as int
    ..AllDayCount = json['AllDayCount'] as int
    ..SellerId = json['SellerId'] as String
    ..CommssionType = json['CommssionType'] as int;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'ID': instance.ID,
      'GoodsId': instance.GoodsId,
      'GoodsName': instance.GoodsName,
      'GoodsClass': instance.GoodsClass,
      'GoodsLink': instance.GoodsLink,
      'ActLink': instance.ActLink,
      'ImgUrl': instance.ImgUrl,
      'ActMoney': instance.ActMoney,
      'GoodsPrice': instance.GoodsPrice,
      'LastPrice': instance.LastPrice,
      'BeginDate': instance.BeginDate,
      'EndDate': instance.EndDate,
      'SaleCount': instance.SaleCount,
      'TKMoneyRate': instance.TKMoneyRate,
      'TjRemark': instance.TjRemark,
      'Coupon_Count': instance.CouponCount,
      'Coupon_SaleCount': instance.CouponSaleCount,
      'ly': instance.ly,
      'MarketImage': instance.MarketImage,
      'ActivityType': instance.ActivityType,
      'OrderCount': instance.OrderCount,
      'TowHourCount': instance.TowHourCount,
      'AllDayCount': instance.AllDayCount,
      'SellerId': instance.SellerId,
      'CommssionType': instance.CommssionType
    };
