///需要登录的异常
class NeedLogin extends FwNetError {
  NeedLogin({int code = 401, String message = '请先登录'}) : super(code, message);
}

///需要授权的异常
class NeedAuth extends FwNetError {
  NeedAuth(String message, {int code = 403, dynamic data})
      : super(code, message, data: data);
}

///网络异常统一格式类
class FwNetError implements Exception {
  final int code;
  final String message;
  final dynamic data;

  FwNetError(this.code, this.message, {this.data});
}
