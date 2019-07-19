import 'package:flutter/material.dart';
import 'package:flutter_merge/tqx/ui/search_page.dart';
import 'sub/product_page.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_merge/tqx/widget/swiper/without_control.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();
}

var title = ['精选推荐', '女装', '男装', '内衣', '母婴', '化妆品', '家居',
'鞋包配饰', '美食', '文体车品', '数码家电'];

var banners = ['ic_banner_first.png', 'ic_banner_second.png'];

var loopText = ['保暖内衣', '耳机', '口红', '懒人火锅', 'T恤', '内裤', '耳钉', '帽子'];

TabController _tabController;

// home_page 最外层
class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive {
    return true;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: title.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: title.length,
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 36.0,
                decoration: BoxDecoration(color: Color(0xffdddddd), borderRadius: BorderRadius.all(Radius.circular(5.0))),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.search),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0),
                        child: Swiper(
                          onTap: (index) {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return SearchPage();
                            }));
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: loopText.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: FractionalOffset.centerLeft,
                              child: Text('大家都在搜：${loopText[index]}'),

                            );
                          },
                          autoplayDelay: 2500,
                          duration: 1500,
                          autoplay: true,
                          control: SwipeWithoutControl(),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                height: 150.0,
                child: Swiper(
                    itemBuilder: (context, index) {
                      return Image.asset('images/3.0x/' + banners[index], fit: BoxFit.cover,);
                    },
                    itemCount: banners.length,
                    autoplay: true,
//                    每一页停留时间
                    autoplayDelay: 3000,
//                    切换过程的时间
                    duration: 1000,
//                      left right arrow
                    control: SwipeWithoutControl(),
//                      指示圆点
                    pagination: SwiperPagination(
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.grey,
                      ),
                    ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _MSliverPersistentHeaderDelegate(
                child: TabBarLayout(),
              ),
            ),
          ];
        },
        body: TabBarVP(controller: _tabController),
      ),
    );
  }
}

// appbarLayout
class _MSliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {

  final Widget child;

  _MSliverPersistentHeaderDelegate({@required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return SizedBox.expand(child: child,);
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return maxExtent != oldDelegate.maxExtent
        || minExtent != oldDelegate.minExtent;
  }
}

// tabBarLayout
class TabBarLayout extends StatefulWidget {

  @override
  _TabBarLayoutState createState() => new _TabBarLayoutState();
}

class _TabBarLayoutState extends State<TabBarLayout> {

  Color _primaryColor, _normalColor;

  @override
  void initState() {
    super.initState();
    _primaryColor = Color(0xff1384ff);
    _normalColor = Colors.black;
  }


  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Widget> _buildTab() {
    return title.map((item) =>
        Text('$item', style: TextStyle(fontSize: 15),)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Colors.white,
      child: TabBar(
          tabs: _buildTab(),
          controller: _tabController,
          isScrollable: true,
          indicatorColor: _primaryColor,
          labelColor: _primaryColor,
          unselectedLabelColor: _normalColor,
      ),
    );
  }
}

// 与tabBarLayout 配合的 viewPager
class TabBarVP extends StatelessWidget {

  final TabController controller;

  TabBarVP({@required this.controller});

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [];
    for (int i = 0; i < 11; i++) {
      pages.add(ProductListPage(index: i));
    }
    return TabBarView(
        children: pages,
        controller: controller,
    );
  }
}

