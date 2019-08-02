import 'package:flutter/material.dart';

/// 共享widget
class HeroAnimPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: InkWell(
          child: Hero(
            tag: 'avatar',
            child: ClipOval(
              child: Image.asset('images/3.0x/ic_banner_first.png', width: 80.0, height: 80.0,),
            ),
          ),
          onTap: () {
            Navigator.push(context, PageRouteBuilder(
              pageBuilder: (ctx, anim, animSec) {
                return FadeTransition(
                  opacity: anim,
                  child: _HeroTagPage(),
                );
              },
            ));
          },
        ),
      ),
    );
  }
}

class _HeroTagPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('原图'),),
      body: Center(
        child: Hero(tag: 'avatar', child: Image.asset('images/3.0x/ic_banner_first.png')),
      ),
    );
  }
}