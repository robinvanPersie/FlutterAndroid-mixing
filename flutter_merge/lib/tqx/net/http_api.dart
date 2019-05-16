

class Api {
  /**
   * 普通商品API
   */
  static const DATA_INDEX = 'DataApi/index';

  /**
   * 销量排行榜
   * type:  4:2小时，3:全天
   */
  static const DATA_TOP100 = 'DataApi/Top100';

  /**
   * 选单预告：推荐明日预告
   * @param type 1.今天 2.明天 3.今天明天
   */
  static const DATA_HOT_GOODS = 'DataApi/HotGoods';
}