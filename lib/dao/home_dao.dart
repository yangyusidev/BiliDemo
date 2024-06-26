import 'package:flutter_demo/http/core/fw_net.dart';
import 'package:flutter_demo/http/request/base_request.dart';
import 'package:flutter_demo/http/request/home_request.dart';
import 'package:flutter_demo/model/home_model.dart';

class HomeDao {

  static const AUTHORIZATION = "authorization";
  static const LOGIN = 0;
  static const REGISTER = 1;

  static loadHomeRecommend(int tid,
      {int pageIndex = 1, int pageSize = 1}) async {
    print("当前tid:$tid");
    BaseRequest request = HomeVideoRequest();
    request
        .add("tid", tid)
        .add("pageIndex", pageIndex)
        .add("pageSize", pageSize);
    var result = await FwNet.getInstance().fire(request);
    return ResponseData.fromJson(result).list;
  }
}
