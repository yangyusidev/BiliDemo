import 'package:flutter_demo/http/core/adapter/dio_adapter.dart';
import 'package:flutter_demo/http/core/fw_error.dart';
import 'package:flutter_demo/http/request/base_request.dart';

import 'adapter/net_adapter.dart';

class FwNet {
  FwNet._();

  static FwNet? _instance;

  static FwNet getInstance() {
    if (_instance == null) {
      _instance = FwNet._();
    }
    return _instance!;
  }

  FwErrorInterceptor? _fwErrorInterceptor;

  Future fire(BaseRequest request) async {
    FwNetResponse? response;
    var error;
    try {
      response = await send(request);
    } on FwNetError catch (e) {
      error = e;
      response = e.data;
      printLog(e.message);
    } catch (e) {
      //其它异常
      error = e;
      printLog(e);
    }
    if (response == null) {
      printLog(error);
    }
    var result = response?.data;
    printLog(result);
    var status = response?.statusCode;
    var hiError;
    switch (status) {
      case 200:
        return result;
      case 401:
        hiError = NeedLogin();
        break;
      case 403:
        hiError = NeedAuth(result.toString(), data: result);
        break;
      default:
        //如果error不为空，则复用现有的error
        hiError =
            error ?? FwNetError(status ?? -1, result.toString(), data: result);
        break;
    }
    //交给拦截器处理错误
    if (_fwErrorInterceptor != null) {
      _fwErrorInterceptor!(hiError);
    }
    throw hiError;
  }

  //适配器模式，不同的架子，做不同的适配，实际上就是一个代理
  Future<FwNetResponse<T>> send<T>(BaseRequest request) async {
    /// 使用Dio发送请求
    FwNetAdapter adapter = DioAdapter();
    // FwNetAdapter adapter = MockAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('fw_net$log');
  }

  void setErrorInterceptor(FwErrorInterceptor interceptor) {
    this._fwErrorInterceptor = interceptor;
  }
}
