import 'package:flutter/material.dart';
import 'package:flutter_demo/core/fw_state.dart';
import 'package:flutter_demo/dao/home_dao.dart';
import 'package:flutter_demo/navigator/fw_navigator.dart';
import 'package:flutter_demo/util/color.dart';
import 'package:flutter_demo/util/view_util.dart';
import 'package:flutter_demo/widget/loading_container.dart';
import 'package:flutter_demo/widget/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:underline_indicator/underline_indicator.dart';

import '../model/home_model.dart';
import '../theme/theme_provider.dart';
import 'home_tab_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends FwState<HomePage>
    with
        AutomaticKeepAliveClientMixin,
        TickerProviderStateMixin,
        WidgetsBindingObserver {
  var listener;
  List<HomeMo>? data = [];

  late TabController _controller;
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片·手书·配音"];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    FwNavigator.getInstance().addListener(this.listener = (current, pre) {
      if (widget == current.page || current.page is HomePage) {
        print('打开了首页:onResume');
      } else if (widget == pre?.page || pre?.page is HomePage) {
        print('首页:onPause');
      }
    });

    loadData();
  }

  ///监听应用生命周期变化
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(':didChangeAppLifecycleState:$state');
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        //fix Android压后台首页状态栏字体颜色变白，详情页状态栏字体变黑问题
        changeStatusBar();
        break;
      case AppLifecycleState.paused: // 界面不可见，后台
        break;
      case AppLifecycleState.detached: // APP结束时调用
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// 监听系统变化
  @override
  void didChangePlatformBrightness() {
    context.read<ThemeProvider>().darModeChange();
    super.didChangePlatformBrightness();
  }

  @override
  void dispose() {
    FwNavigator.getInstance().removeListener(this.listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Column(
          children: [
            NavigationBarPlus(
              child: _appBar(),
              height: 50,
              color: Colors.white,
              statusStyle: StatusStyle.DARK_CONTENT,
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 5),
              child: _tabBar(),
            ),
            Flexible(
                child: TabBarView(
              controller: _controller,
              children: tabs.map((tab) {
                return HomeTabPage();
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  ///自定义顶部tab
  _tabBar() {
    return TabBar(
        controller: _controller,
        isScrollable: true,
        indicator: const UnderlineIndicator(
            strokeCap: StrokeCap.round,
            borderSide: BorderSide(color: primary, width: 3),
            insets: EdgeInsets.only(left: 15, right: 15)),
        tabs: tabs.map<Tab>((tab) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Text(
                tab,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList());
  }

  void loadData() async {
    List<HomeMo> homeData = await HomeDao.loadHomeRecommend(0);
    print("===================data:$data");
    setState(() {
      data = homeData;
      _isLoading = false;
    });
  }

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Row(
        children: [
          InkWell(
            onTap: () {},
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: const Image(
                height: 46,
                width: 46,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          )),
          const Icon(
            Icons.explore_outlined,
            color: Colors.grey,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
