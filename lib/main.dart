import 'package:flutter/material.dart';
import 'package:flutter_demo/http/core/fw_net.dart';
import 'package:flutter_demo/pages/demo_home_page.dart';
import 'package:flutter_demo/pages/demo_target2_page.dart';
import 'package:flutter_demo/pages/demo_target_page.dart';

import 'http/request/test_request.dart';
import 'navigator/fw_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  BiliRouterDelegate _biliRouterDelegate = BiliRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Router(
          routerDelegate: _biliRouterDelegate,
        ));
  }
}

MaterialPage pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

class BiliRouterDelegate extends RouterDelegate<BiliRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRouterPath> {
  BiliRouterPath? path;

  List<MaterialPage> pages = [];

  // 当前页面
  RouteStatus _routeStatus = RouteStatus.home;

  RouteStatus get routeStatus => _routeStatus;

  Map? _args;

  BiliRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    FwNavigator.getInstance().registerRouterJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      _args = args;
      notifyListeners();
    }));
  }

  @override
  GlobalKey<NavigatorState>? navigatorKey;

  /**
   * 管理栈区
   */
  managerStack() {
    // 获取在栈区中的位置
    var index = getPageIndex(pages, routeStatus);

    // 截取栈区
    List<MaterialPage> temPages = pages;
    if (index != -1) {
      temPages = temPages.sublist(0, index);
    }

    var page = getPage(routeStatus);
    // ...扩展运算符，相当于把原来的所有元素加到新的List
    temPages = [...temPages, page];
    pages = temPages;
  }

  MaterialPage getPage(RouteStatus status) {
    var page;
    if (status == RouteStatus.home) {
      page = pageWrap(DemoHomePage());
    } else if (status == RouteStatus.target) {
      page = pageWrap(DemoTargetPage());
    } else if (status == RouteStatus.target2) {
      page = pageWrap(DemoTargetPage2(args: _args,));
    }
    return page;
  }

// 页面处理
  @override
  Widget build(BuildContext context) {
    managerStack();
    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRouterPath path) async {
    this.path = path;
  }
}

class BiliRouterPath {
  final String location;

  BiliRouterPath.home() : location = "/";

  BiliRouterPath.detail() : location = "/detail";
}
