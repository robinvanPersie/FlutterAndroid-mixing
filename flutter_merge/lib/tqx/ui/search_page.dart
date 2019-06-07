import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/common/colors.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

var searchTags = ['保暖内衣', '帽子', '懒人火锅', '手机壳', '护肤套装', '耳机',
'加湿器', '零食大礼包', '耳钉', '内裤', '口红', 'T恤', '面膜', '袜子', '卫衣'];

class _SearchPageState extends State<SearchPage> {

  List<Widget> tags = List();
  String key = '';

  @override
  void initState() {
    super.initState();
    searchTags.map((tag) {
      GestureDetector g = GestureDetector(
        onTap: (){
          print(tag);
          setState(() {
            key = tag;
          });
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.all(Radius.circular(3.0),),
          ),
          child: Text(tag, style: TextStyle(fontSize: 12.0),),
        ),
      );
      tags.add(g);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController  _controller = TextEditingController.fromValue(TextEditingValue(
      text: key,
      selection: TextSelection.fromPosition(TextPosition(
        affinity: TextAffinity.downstream,
        offset: key == null ? 0 : key.length,
      ))
    ));
    return CustomizeScaffold(
      title: '搜索',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 改变底部横线颜色
          Theme(
            data: ThemeData(primaryColor: Colors.grey, hintColor: Colors.grey),
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colorful.TEXT_GREY,),
                suffixIcon: IconButton(
                  onPressed: () {
                    _controller.clear();
                  },
                  icon: Icon(Icons.clear, color: Colorful.TEXT_GREY,),
                ),
                border: UnderlineInputBorder(),
//              fillColor: Colors.grey,
                contentPadding: EdgeInsets.all(13.0),
                hintText: '输入商品名称或黏贴淘宝标题',
                hintStyle: TextStyle(fontSize: 13.0, color: Colorful.TEXT_GREY),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 15.0, top: 10.0),
            child: Text('大家都在搜'),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
            child: Wrap(
              children: tags,
              spacing: 10.0,
            ),
          ),
        ],
      ),
    );
  }
}
