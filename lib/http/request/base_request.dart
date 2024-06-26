import 'package:flutter_demo/http/db/fw_cache.dart';

enum HttpMethod { GET, POST, DELETE }

abstract class BaseRequest {
  // 统一的域名
  String authority() {
    return "api.bilibili.cn";
  }

  String authorization() {
    return "authorization";
  }

  String getToken() {
    return FwCache.getInstance().get(authorization());
  }

  // 参数
  var pathParams;
  Map<String, String> params = Map();

  // 请求头
  Map<String, dynamic> header = {};

  // 往下延申的相关字段
  // 地址
  String path();

  // 请求方案get,post
  HttpMethod httpMethod();

  // 是否登录
  bool needLogin();

  //是否是HTTPS
  bool isHttps = true;

  ///参数录入
  ///添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  ///添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }

  String url() {
    Uri uri;

    var pathStr = path();

    // 参数处理
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }

    var param;
    if (params.isNotEmpty && httpMethod() == HttpMethod.GET) {
      param = params;
    }

    if (isHttps) {
      uri = Uri.https(authority(), pathStr, param);
    } else {
      uri = Uri.http(authority(), pathStr, param);
    }

    if (needLogin()) {
      String auth = FwCache.getInstance().get(authorization());
      addHeader(authorization(), auth);
    }

    return uri.toString();
  }
}
