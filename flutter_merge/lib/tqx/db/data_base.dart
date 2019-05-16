import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter_merge/tqx/model/goods.dart';
import 'package:synchronized/synchronized.dart';

class MDatabase {

  Database _database;

  MDatabase._(){}

  // 静态私有成员
  static MDatabase _instance;
  // getInstance()
  static MDatabase _getInstance() {
    if (_instance == null) {
      _instance = MDatabase._();
    }
    return _instance;
  }

  factory MDatabase() => _getInstance();

  // db name
  static const DB_NAME = 'tqx_flutter.db';
  // db version
  static const DB_VERSION = 1;
  // table name
  final String T_FAVORITE_CREATE = 'CREATE TABLE IF NOT EXISTS T_FAVORITE (_ID INTEGER PRIMARY KEY, GOODS_ID LONG, NAME VARCHAR(50), ACT_LINK TEXT, IMAGE_URL TEXT, ACT_MONEY INTEGER, GOODS_PRICE FLOAT, LAST_PRICE FLOAT, BEGIN_DATE VARCHAR(30), END_DATE VARCHAR(30), SALE_COUNT INTEGER, LY INTEGER DEFAULT 2)';
  final String T_FOOTPRINT_CREATE = "CREATE TABLE IF NOT EXISTS T_FOOTPRINT (_ID INTEGER PRIMARY KEY, GOODS_ID LONG, NAME VARCHAR(50), ACT_LINK TEXT, IMAGE_URL TEXT, ACT_MONEY INTEGER, GOODS_PRICE FLOAT, LAST_PRICE FLOAT, BEGIN_DATE VARCHAR(30), END_DATE VARCHAR(30), SALE_COUNT INTEGER, LY INTEGER DEFAULT 2)";

  final _lock = new Lock();

  Future get db async {
    if (_database == null) {
      await _lock.synchronized(() async {
        if (_database == null) {
          _database = await _openDB();
        }
      });
    } else {
      print('database already exist');
    }
    return _database;
  }

  _openDB() async {
//    var appDir = await getApplicationDocumentsDirectory();
    var dir = await getDatabasesPath();
    var path = join(dir, DB_NAME);

//    print('app dir: $appDir');
    print('\n');
    print('db path: $path');

    Directory directory = Directory(dirname(path));
    if (await directory.exists()) {
    } else {
      await Directory(dir).create(recursive: true).catchError((e) {
        print(e);
      });
    }
    Database database = await openDatabase(path, version: DB_VERSION, onCreate: _onCreate, onUpgrade: _onUpgrade);
    print('db create success');
    return database;
  }

  closeDb() async {
    Database mDb = await db;
    mDb.close();
    print('关闭成功');
  }

  _onCreate(Database db, int version) async {
    await db.execute(T_FAVORITE_CREATE);
  }

  _onUpgrade(db, oldVersion, newVersion) async {

  }

  insertProduct(Goods goods) async {
    Database mDb = await db;
    await mDb.transaction((txn) async {
      String sql = 'INSERT INTO T_FAVORITE (GOODS_ID, NAME, ACT_LINK, IMAGE_URL, ACT_MONEY, GOODS_PRICE, LAST_PRICE, BEGIN_DATE, END_DATE, SALE_COUNT, LY)'
          + ' VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
      txn.rawInsert(sql, [goods.ID, goods.goodsName, goods.actLink, goods.imgUrl, goods.actMoney, goods.goodsPrice, goods.lastPrice, goods.beginDate,
      goods.endDate, goods.saleCount, goods.ly]);
      print('insert end');
    });
  }

  queryProduct() async {
    Database mDb = await db;
    List<Map> list = await mDb.rawQuery('SELECT * FROM T_FAVORITE');
//    List<Goods> goods = List();
//    list.forEach((map) => {
//      goods.add(Goods.fromSql(map));
//    });
    return list;
  }
}