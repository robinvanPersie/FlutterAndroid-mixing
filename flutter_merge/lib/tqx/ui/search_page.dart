import 'package:flutter/material.dart';

import 'package:flutter_merge/tqx/widget/customize_scaffold.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return CustomizeScaffold(
      title: '搜索',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
          ),
        ],
      ),
    );
  }
}
