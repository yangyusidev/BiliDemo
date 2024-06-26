import 'package:flutter/material.dart';

class DemoTargetPage extends StatefulWidget {

  const DemoTargetPage({Key? key}) :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DemoTargetPage();
  }
}

class _DemoTargetPage extends State<DemoTargetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
            children: [
            Text("测试页面"), MaterialButton(onPressed: () {})
        ],
      ),
    ),);
  }
}