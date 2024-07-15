import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Defend {
  run(Widget app) {
    //框架异常
    FlutterError.onError = (FlutterErrorDetails details) async {
      //线上环境，走上报逻辑
      if (kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        //开发期间，走Console抛出
        FlutterError.dumpErrorToConsole(details);
      }
    };

    /// flutter运行过程中，类似于沙箱模式的处理方案
    /// 捕捉未捕捉的异常
    runZonedGuarded<Future<Null>>(() async {
      runApp(app);
    }, (e, s) => _reportError(e, s));
  }

  ///通过接口上报
  Future<Null> _reportError(Object error, StackTrace stack) async {
    print('catch error：$error');
  }
}
