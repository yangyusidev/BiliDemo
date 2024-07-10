import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/barrage_model.dart';

abstract class ISocket {
  ///和服务器建立连接
  ISocket open(String vid);

  ///发送弹幕
  ISocket send(String message);

  ///关闭连接
  void close();

  ///接受弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}

/// websocket http保留链接的存在
/// nginx服务器处理链接保留
/// 60秒断开
class FwSocket implements ISocket {
  static const _URL = 'ws://192.168.31.23:8080/websocket/message/';
  IOWebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;
  final Map<String, dynamic>? headers;
  int _intervalSeconds = 50;

  FwSocket({this.headers});

  @override
  void close() {
    _channel?.sink.close();
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
    _callBack = callBack;
    return this;
  }

  @override
  ISocket open(String vid) {
    if (headers != null) {
      _channel = IOWebSocketChannel.connect(_URL + vid,
          headers: headers, pingInterval: Duration(seconds: _intervalSeconds));
    } else {
      _channel = IOWebSocketChannel.connect(_URL + vid,
          pingInterval: Duration(seconds: _intervalSeconds));
    }
    _channel?.stream.handleError((error) {
      print("连接失败，发生错误$error");
    }).listen((message) {
      //开始监听websocket的消息
      _handleMessage(message);
    });
    return this;
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  void _handleMessage(message) {
    print("message:$message");
    var result = BarrageModel.fromJsonString(message);
    if (_callBack != null) {
      _callBack!(result);
    }
  }
}
