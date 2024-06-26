import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///我的
class ProfilePage extends StatefulWidget{
  @override
  _ProfilePage createState() => _ProfilePage();

}

class _ProfilePage extends State<ProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text('我的'),
      ),
    );
  }
}