import 'package:flutter_demo/db/fw_cache.dart';
import 'package:flutter_demo/http/core/fw_net.dart';
import 'package:flutter_demo/http/request/base_request.dart';
import 'package:flutter_demo/http/request/user_request.dart';

class UserDao {
  static const AUTHORIZATION = "authorization";
  static const LOGIN = 0;
  static const REGISTER = 1;

  static login(String userName, String password) {
    return _send(userName, password, LOGIN);
  }

  static registration(String userName, String password) {
    return _send(userName, password, REGISTER);
  }

  static _send(String userName, String password, int requestCode) async {
    BaseRequest request;

    switch (requestCode) {
      case REGISTER:
        request = RegistrationRequest();
        break;
      case LOGIN:
        request = LoginRequest();
        break;
      default:
        return;
    }
    request.add("userName", userName).add("password", password);
    var result = await FwNet.getInstance().fire(request);
    print(result);
    if (result['code'] == 0 && result['data'] != null) {
      // 保存登录令牌
      FwCache.getInstance().setString(request.authorization(), result['data']);
    }
    print("token:${getToken()}");
    return result;
  }

  static getToken() {
    return FwCache.getInstance().get(AUTHORIZATION);
  }
}
