import 'package:flutter_demo/net/http/core/adapter/net_adapter.dart';
import 'package:flutter_demo/net/http/request/base_request.dart';

class MockAdapter extends FwNetAdapter {
  @override
  Future<FwNetResponse<T>> send<T>(BaseRequest request) async {
    return Future.delayed(Duration(milliseconds: 1000), () {
      return FwNetResponse(
          request: request,
          data: {"code": 0, "message": 'success', "data": "data"} as T,
          statusCode: 200);
    });
  }
}
