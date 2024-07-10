import 'package:flutter/material.dart';
import 'package:flutter_demo/dao/user_dao.dart';
import 'package:flutter_demo/net//http/core/fw_error.dart';
import 'package:flutter_demo/widget/appbar.dart';
import 'package:flutter_demo/widget/login_button.dart';
import 'package:flutter_demo/widget/login_effect.dart';
import 'package:flutter_demo/widget/login_input.dart';

import '../util/string_util.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  String? userName;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {}),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              '用户名',
              '请输入用户',
              obscureText: true,
              onChanged: (text) {
                userName = text;
                checkInput();
              },
            ),
            LoginInput(
              '密码',
              '请输入密码',
              obscureText: true,
              onChanged: (text) {
                password = text;
                checkInput();
              },
              focusChanged: (focus) {
                this.setState(() {
                  protect = focus;
                });
              },
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: LoginButton(
                '登录',
                enable: loginEnable,
                onPressed: send,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(userName) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    print("object");
    try {
      var result = await UserDao.login(userName!, password!);
      print(result);
      if (result['code'] == 0) {
        print('登录成功');
      } else {
        print(result['msg']);
      }
    } on NeedAuth catch (e) {
      print(e);
    } on FwNetError catch (e) {
      print(e);
    }
  }
}
