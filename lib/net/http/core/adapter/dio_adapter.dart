import 'package:flutter_demo/net/http/core/adapter/net_adapter.dart';
import 'package:flutter_demo/net/http/core/fw_error.dart';
import 'package:flutter_demo/net/http/request/base_request.dart';
import 'package:dio/dio.dart';

class DioAdapter extends FwNetAdapter {
  @override
  Future<FwNetResponse<T>> send<T>(BaseRequest request) async {
    var response, options = Options(headers: request.header);
    var error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      ///抛出FwNetError
      throw FwNetError(response?.statusCode ?? -1, error.toString(),
          data: await buildRes(response, request));
    }
    return buildRes(response, request);
  }

  Future<FwNetResponse<T>> buildRes<T>(
      Response? response, BaseRequest request) {
    return Future.value(FwNetResponse(
        data: response?.data,
        request: request,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
        extra: response));
  }
}
