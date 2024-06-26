import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/demo_home_page.dart';
import 'package:flutter_demo/pages/demo_target_page.dart';

import '../pages/demo_target2_page.dart';

enum RouteStatus { login, registration, home, detail, unknown, target, target2 }

RouteStatus getStatus(MaterialPage page) {
  if (page.child is DemoHomePage) {
    return RouteStatus.home;
  } else if (page.child is DemoTargetPage) {
    return RouteStatus.target;
  } else if (page.child is DemoTargetPage2) {
    return RouteStatus.target2;
  } else {
    return RouteStatus.unknown;
  }
}

class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

///获取routeStatus在页面栈中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

class FwNavigator extends _RouteJumpListener {
  static FwNavigator? _instance;
  RouteJumpListener? _routeJump;

  FwNavigator._();

  static FwNavigator getInstance() {
    if (_instance == null) {
      _instance = FwNavigator._();
    }
    return _instance!;
  }

  void registerRouterJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }
}

///抽象类供FwNavigator实现
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

///定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  final OnJumpTo onJumpTo;

  RouteJumpListener({required this.onJumpTo});
}
