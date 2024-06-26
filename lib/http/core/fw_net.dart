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
    switch (status) {
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(result.toString(), data: result);
      default:
        throw FwNetError(status ?? -1, result.toString(), data: result);
    }
  }

  Future<FwNetResponse<T>> send<T>(BaseRequest request) async {
    /// 使用Dio发送请求
    FwNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }

  void printLog(log) {
    print('fw_net$log');
  }
}
