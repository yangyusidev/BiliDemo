import 'package:flutter/material.dart';
import 'package:flutter_demo/navigator/bottom_navigator.dart';
import 'package:flutter_demo/page/demo_target_page.dart';
import 'package:flutter_demo/page/login_page.dart';
import 'package:flutter_demo/page/registration_page.dart';
import 'package:flutter_demo/page/video_detail_page.dart';

typedef RouteChangeListener(RouteStatusInfo current, RouteStatusInfo? pre);

///创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
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

///自定义路由封装，路由状态
enum RouteStatus {
  login,
  registration,
  home,
  detail,
  unknown,
  target,
  target2,
  darkMode
}

///获取page对应的RouteStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  } else if (page.child is BottomNavigator) {
    return RouteStatus.home;
  } else if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  } else if (page.child is DemoTargetPage) {
    return RouteStatus.target;
  } else {
    return RouteStatus.unknown;
  }
}

///路由信息
class RouteStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouteStatusInfo(this.routeStatus, this.page);
}

///监听路由页面跳转
///感知当前页面是否压后台
class FwNavigator extends _RouteJumpListener {
  static FwNavigator? _instance;
  RouteJumpListener? _routeJump;

  List<RouteChangeListener> _listeners = [];
  RouteStatusInfo? _current;

  RouteStatusInfo? _bottomtab;

  FwNavigator._();

  static FwNavigator getInstance() {
    if (_instance == null) {
      _instance = FwNavigator._();
    }
    return _instance!;
  }

  ///首页底部tab切换监听
  void onBottomTabChange(int index, Widget page) {
    _bottomtab = RouteStatusInfo(RouteStatus.home, page);
    _notify(_bottomtab!);
  }

  ///注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    this._routeJump = routeJumpListener;
  }

  ///监听路由页面跳转
  void addListener(RouteChangeListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  ///移除监听
  void removeListener(RouteChangeListener listener) {
    _listeners.remove(listener);
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJump?.onJumpTo(routeStatus, args: args);
  }

  void notify(List<MaterialPage> currentPages, List<MaterialPage> prePages) {
    if (currentPages == prePages) return;
    var current =
        RouteStatusInfo(getStatus(currentPages.last), currentPages.last.child);
    _notify(current);
  }

  void _notify(RouteStatusInfo current) {
    if (current.page is BottomNavigator && _bottomtab != null) {
      //如果打开的是首页，则明确到首页具体的tab
      current = _bottomtab!;
    }
    print('navigator:current:${current.page}');
    print('navigator:pre:${_current?.page}');
    _listeners.forEach((listener) {
      listener(current, _current);
    });
    _current = current;
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
