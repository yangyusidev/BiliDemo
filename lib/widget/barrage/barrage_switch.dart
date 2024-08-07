//barrage.dart
import 'package:flutter/material.dart';

import '../../../../util/color.dart';

class BarrageSwitch extends StatefulWidget {
  ///初始时是否展开
  final bool initSwitch;

  ///是否为输入中
  final bool inoutShowing;

  ///输入框切换回调
  final VoidCallback onShowInput;

  ///展开与伸缩状态切换回调
  final ValueChanged<bool> onBarrageSwitch;

  const BarrageSwitch(
      {Key? key,
      this.initSwitch = true,
      required this.onShowInput,
      required this.onBarrageSwitch,
      this.inoutShowing = false})
      : super(key: key);

  @override
  _BarrageSwitchState createState() => _BarrageSwitchState();
}

class _BarrageSwitchState extends State<BarrageSwitch> {
  late bool _barrageSwitch;

  @override
  void initState() {
    super.initState();
    _barrageSwitch = widget.initSwitch;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: EdgeInsets.only(left: 10, right: 10),
      margin: EdgeInsets.only(right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [_buildText(), _buildIcon()],
      ),
    );
  }

  _buildText() {
    var text = widget.inoutShowing ? '弹幕输入中' : '点我发弹幕';
    return _barrageSwitch
        ? InkWell(
            onTap: () {
              widget.onShowInput();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: Text(text,
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ),
          )
        : Container();
  }

  _buildIcon() {
    return InkWell(
      onTap: () {
        setState(() {
          _barrageSwitch = !_barrageSwitch;
        });
        widget.onBarrageSwitch(_barrageSwitch);
      },
      child: Icon(
        Icons.live_tv_rounded,
        color: _barrageSwitch ? primary : Colors.grey,
      ),
    );
  }
}
