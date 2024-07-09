import 'package:flutter/material.dart';

class DemoTargetPage2 extends StatefulWidget {
  Map? args;

  DemoTargetPage2({Key? key, this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DemoTargetPage2();
  }
}

class _DemoTargetPage2 extends State<DemoTargetPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("这是第三个页面，数据是:${widget.args?["data"]}"),
            MaterialButton(onPressed: () {})
          ],
        ),
      ),
    );
  }
}
