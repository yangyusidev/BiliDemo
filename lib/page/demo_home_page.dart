import 'package:flutter/material.dart';
import 'package:flutter_demo/navigator/fw_navigator.dart';

class DemoHomePage extends StatefulWidget {
  // VoidCallback onToTarget;

  DemoHomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DemoHomePageState();
  }
}

class _DemoHomePageState extends State<DemoHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("主页"),
            MaterialButton(
              onPressed: () {
                Map args = {"data": "这个是数据..."};
                FwNavigator.getInstance()
                    .onJumpTo(RouteStatus.target, args: args);
              },
              child: Text("跳转"),
            )
          ],
        ),
      ),
    );
  }
}
