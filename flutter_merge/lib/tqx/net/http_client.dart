import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_merge/tqx/model/product_bean.dart';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:flutter_merge/tqx/net/http_api.dart';

// 回调
typedef ReqCallback<T> = void Function(T result);
typedef ErrorCallback = void Function(int code, String msg);

class HttpClient {

  Dio dio = Dio();
  String APP_KEY = "lfcbskm73a";

  //饿汉

  // 私有构造
  HttpClient._() {
    _initConfig();
  }
  // 静态私有成员
  static HttpClient _instance = HttpClient._();
  // getInstance()
  static HttpClient _getInstance() => _instance;

  factory HttpClient() => _getInstance();

  _initConfig() {
    dio.options.baseUrl = 'http://api.xuandan.com/';
    dio.options.connectTimeout = 5000;
    dio.options.receiveTimeout = 5000;
  }

  Future<Response<dynamic>> _executeGet(String path, {Map<String, dynamic> params,}) async {
//  Future<dynamic> _executeGet(String path, {Map<String, dynamic> params,}) async {
    params.putIfAbsent('appkey', () {
      return APP_KEY;
    });
    final result = await dio.get('$path', queryParameters: params);
    return result;
  }
  /**
   * 商城产品列表
   * @params type 商品类型，与tab index对应
   */
  getProductList({int cId, int page, ReqCallback callback, ErrorCallback errorCb}) async {
    var response = _executeGet(Api.DATA_INDEX, params: {'page': page, 'cid': cId});
    response.then((r) {
      int code = r.statusCode;
      if (code == 200) {
//        Map map = json.decode(r.data);
//        ListProduct lp = ListProduct.fromJson(map);

        var resultList = r.data['data'];
        List<Goods> list =
        resultList.map<Goods>((item) => Goods.fromJson(item)).toList();
        callback({'list': list});
//        if (lp.code == 0) {
//          callback(list);
//        } else {
//          errorCb(lp.code, lp.msg);
//        }
      } else {
        errorCb(-1, 'er msg');
      }
    }).catchError((error) {
       print(error);
       errorCb(-2, '-2 er msg');
    });
  }

  /**
   * 销量排行榜
   * @param type 4: 2小时，3: 全天
   * @return
   */
  getRecommendList(int type, ReqCallback callback) async {
    var response = _executeGet(Api.DATA_TOP100, params: {'type': type});
    response.then((r){
      int code = r.statusCode;
      if (code == 200) {
        var resultList = r.data['data'];
        List<Goods> list =
        resultList.map<Goods>((item) => Goods.fromJson(item)).toList();
        callback({'list': list});
      }
    }).catchError((error) {
      print(error);
    });
  }

  /**
   * 推荐页， 明日预告
   */
  getTomorrowProduct(int type, ReqCallback callback) {
    var response = _executeGet(Api.DATA_HOT_GOODS, params: {'type': type});
    response.then((r) {
      if (r.statusCode == 200) {
        var result = r.data['data'];
        List<Goods> list = result.map<Goods>((item) => Goods.fromJson(item)).toList();
        list = list.length > 10 ? list.sublist(0, 10) : list;
        callback({'list': list});
      }
    }).catchError((error) {
      print(error);
    });
  }
}
