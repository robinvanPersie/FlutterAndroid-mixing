class Goods {
  num ID;
  String goodsId;
  String goodsName;
  String goodsClass;
  String goodsLink;
  String actLink;
  String imgUrl;
  num actMoney;
  double goodsPrice;
  double lastPrice;
  String beginDate;
  String endDate;
  num saleCount;
  num tKMoneyRate;
  String tjRemark;
  num couponCount;
  num couponSaleCount;
  int ly;
  String marketImage;
  int activityType;
  num orderCount;
  num towHourCount;
  num allDayCount;
  String sellerId;
  num commssionType;
  String shopName;
  String video;
  num commissionTwo;
  num commissionDay;
  num couponStartFee;

  Goods.fromJson(Map json)
      : ID = json['ID'],
        goodsId = json['GoodsId'],
        goodsName = json['GoodsName'],
        goodsClass = json['GoodsClass'],
        goodsLink = json['GoodsLink'],
        actLink = json['ActLink'],
        imgUrl = json["ImgUrl"],
        actMoney = json["ActMoney"],
        goodsPrice = json["GoodsPrice"],
        lastPrice = json["LastPrice"],
        beginDate = json["BeginDate"],
        endDate = json["EndDate"],
        saleCount = json["SaleCount"],
        tKMoneyRate = json["TKMoneyRate"],
        tjRemark = json["TjRemark"],
        couponCount = json["Coupon_Count"],
        couponSaleCount = json["Coupon_SaleCount"],
        ly = json["ly"],
        marketImage = json["MarketImage"],
        activityType = json["ActivityType"],
        orderCount = json["OrderCount"],
        towHourCount = json["TowHourCount"],
        allDayCount = json["AllDayCount"],
        sellerId = json["SellerId"],
        commssionType = json["CommssionType"],
        shopName = json["ShopName"],
        video = json["video"],
        commissionTwo = json["commissionTwo"],
        commissionDay = json["commissionDay"],
        couponStartFee = json["couponStartFee"];


// Map toJson() => {
//   'title': title,
//   'descritpion': description,
// };

  Goods.fromSql(Map<String, dynamic> json)
      : ID = json['GOODS_ID'],
        goodsName = json['NAME'],
        actLink = json['ACT_LINK'],
        imgUrl = json['IMAGE_URL'],
        actMoney = json['ACT_MONEY'],
        goodsPrice = json['GOODS_PRICE'],
        lastPrice = json['LAST_PRICE'],
        beginDate = json['BEGIN_DATE'],
        endDate = json['END_DATE'],
        saleCount = json['SALE_COUNT'],
        ly = json['LY'];
}