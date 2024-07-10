import 'package:flutter/material.dart';
import 'package:flutter_demo/page/demo_target2_page.dart';
import 'package:flutter_demo/page/demo_target_page.dart';
import 'package:flutter_demo/page/login_page.dart';
import 'package:flutter_demo/page/registration_page.dart';
import 'package:flutter_demo/page/video_detail_page.dart';

import 'dao/user_dao.dart';
import 'db/fw_cache.dart';
import 'net/http/core/fw_error.dart';
import 'net/http/core/fw_net.dart';
import 'navigator/bottom_navigator.dart';
import 'navigator/fw_navigator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();

  BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Router(
      //   routerDelegate: _routeDelegate,
      // ),
      home: FutureBuilder(
        future: FwCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //预加载没有结束，展示loding
          //结束之后切换路由界面进行展示
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );

          return MaterialApp(
            home: widget,
            theme: ThemeData(primaryColor: Colors.white),
          );
        },
      ),
    );
  }
}

MaterialPage pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

///实际上就是把这个东西作为一个组件进行展示，触发builder切换堆栈
class BiliRouteDelegate extends RouterDelegate<BiliRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRoutePath> {
  BiliRoutePath? path;

  //页面栈
  List<MaterialPage> pages = [];

  //当前页面
  RouteStatus _routeStatus = RouteStatus.home;

  //页面打开拦截
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      return _routeStatus = RouteStatus.login;
    }
    //带入逻辑
    return _routeStatus;
  }

  bool get hasLogin => UserDao.getToken() != null;

  Map? _args;

  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    FwNavigator.getInstance().registerRouteJump(
        RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      _args = args;
      notifyListeners();
    }));

    //设置网络错误拦截器
    FwNet.getInstance().setErrorInterceptor((error) {
      if (error is NeedLogin) {
        //清空失效的登录令牌
        FwCache.getInstance().remove(UserDao.AUTHORIZATION);
        //拉起登录
        FwNavigator.getInstance().onJumpTo(RouteStatus.login);
      }
    });
  }

  @override
  GlobalKey<NavigatorState>? navigatorKey;

  /**
   * 管理栈区
   */
  managerStack() {
    //获取在栈区中的位置
    var index = getPageIndex(pages, routeStatus);
    //截取栈区
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      tempPages = tempPages.sublist(0, index);
    }
    var page = getPage(routeStatus);

    //已经处理的
    //打开
    tempPages = [...tempPages, page];
    FwNavigator.getInstance().notify(tempPages, pages);
    //home --> login
    //原来的，当前页 home
    pages = tempPages;
  }

  MaterialPage getPage(RouteStatus status) {
    var page;
    if (status == RouteStatus.home) {
      print("getpage....");
      pages.clear();
      page = pageWrap(BottomNavigator());
    } else if (status == RouteStatus.target) {
      page = pageWrap(DemoTargetPage());
    } else if (status == RouteStatus.target2) {
      page = pageWrap(DemoTargetPage2(
        args: _args,
      ));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(LoginPage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(_args?["video"]));
    }
    return page;
  }

  //页面处理
  @override
  Widget build(BuildContext context) {
    managerStack();

    //fix Android物理返回键，
    // 无法返回上一页问题@https://github.com/flutter/flutter/issues/66349

    return WillPopScope(
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            // 登录页未登录，返回拦截
            // LoginPage 这个只是你们自己未来要拦截的目标
            // route.settings 回退的目标page
            // print(
            //     "(route.settings as MaterialPage).child:${(route.settings as MaterialPage).child}");
            // if ((route.settings as MaterialPage).child is LoginPage) {
            //   if (!hasLogin) {
            //     return false;
            //   }
            // }

            if (!route.didPop(result)) {
              return false;
            }

            var tempPages = [...pages];
            //关闭页面通知路由变化
            pages.removeLast();
            FwNavigator.getInstance().notify(pages, tempPages);
            return true;
          },
        ),
        onWillPop: () async =>
            !(await navigatorKey?.currentState?.maybePop() ?? false));
  }

  @override
  Future<void> setNewRoutePath(BiliRoutePath path) async {
    this.path = path;
  }
}

class BiliRoutePath {
  final String location;

  BiliRoutePath.home() : location = "/";

  BiliRoutePath.detail() : location = "/detail";
}
