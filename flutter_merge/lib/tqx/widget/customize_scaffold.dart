import 'package:flutter/material.dart';

class CustomizeScaffold extends StatefulWidget {
  
  String title;
  IconData iconData;
  Widget body;
  VoidCallback backPress;
  List<Widget> actions;
  
  CustomizeScaffold({
    @required this.title,
    IconData iconData,
    @required this.body,
    this.backPress,
    this.actions,
  }) : 
      iconData = iconData == null ? Icons.arrow_back : iconData,
      super();
  
  @override
  _CustomizeScaffoldState createState() => new _CustomizeScaffoldState();
}

class _CustomizeScaffoldState extends State<CustomizeScaffold> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
            icon: Icon(widget.iconData), 
            onPressed: widget.backPress == null ? () {
              Navigator.of(context).pop();
            } : widget.backPress,
        ),
        elevation: 0.4,
        actions: widget.actions,
      ),
      body: widget.body,
    );
  }
}
