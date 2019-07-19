import 'package:flutter/material.dart';

class CustomizeScaffold extends StatefulWidget {
  
  final String title;
  final IconData iconData;
  final Widget body;
  final VoidCallback backPress;
  final List<Widget> actions;
  final FloatingActionButton floatingActionButton;
  
  CustomizeScaffold({
    Key key,
    @required this.title,
    IconData iconData,
    @required this.body,
    this.backPress,
    this.actions,
    this.floatingActionButton,
  }) : 
      iconData = iconData == null ? Icons.arrow_back : iconData,
      super(key: key);
  
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
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
