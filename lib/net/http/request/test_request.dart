import 'package:flutter_demo/net/http/request/base_request.dart';

class TestRequest extends BaseRequest{

  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return false;
  }

  @override
  String path() {
    return "x/web-interface/archive/related";
  }

}