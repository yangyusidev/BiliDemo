import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../db/fw_cache.dart';
import '../util/color.dart';
import '../util/constants.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

// 准备一个共享数据
class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  //平台模式状态
  var _platformBrightness = SchedulerBinding.instance.window.platformBrightness;

  ///系统Dark Mode发生变化
  void darModeChange() {
    print("系统Dark Mode发生变化.......");
    //是否发生变化
    if (_platformBrightness !=
        SchedulerBinding.instance.window.platformBrightness) {
      //变更状态
      _platformBrightness = SchedulerBinding.instance.window.platformBrightness;
      //更新
      notifyListeners();
    }
  }

  ///判断是否是Dark Mode
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      //获取系统的Dark Mode
      return SchedulerBinding.instance.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  ///获取主题模式
  ThemeMode getThemeMode() {
    String? theme = FwCache.getInstance().get(Constants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode!;
  }

  ///设置主题
  void setTheme(ThemeMode themeMode) {
    FwCache.getInstance().setString(Constants.theme, themeMode.value);
    notifyListeners();
  }

  ///获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        errorColor: isDarkMode ? FwColor.dark_red : FwColor.red,
        primaryColor: isDarkMode ? FwColor.dark_bg : white,
        // accentColor: isDarkMode ? primary[50] : white,
        //Tab指示器的颜色
        indicatorColor: isDarkMode ? primary[50] : white,
        //页面背景色
        scaffoldBackgroundColor: isDarkMode ? FwColor.dark_bg : white);
    return themeData;
  }
}
