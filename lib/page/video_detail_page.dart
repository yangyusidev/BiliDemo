import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_overlay/flutter_overlay.dart';

import '../api/video.dart';
import '../model/video_detail_model.dart';
import '../model/video_model.dart';
import '../util/view_util.dart';
import '../widget/appbar.dart';
import '../widget/barrage/barrage.dart';
import '../widget/barrage/barrage_input.dart';
import '../widget/barrage/barrage_switch.dart';
import '../widget/expandable_content.dart';
import '../widget/navigation_bar.dart';
import '../widget/tab.dart';
import '../widget/video_header.dart';
import '../widget/video_large_card.dart';
import '../widget/video_toolbar.dart';
import '../widget/video_view_class.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoModel;

  const VideoDetailPage(this.videoModel);

  @override
  _VideoDetailPageState createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论288"];
  VideoDetailMo? videoDetailMo;
  VideoModel? videoModel;
  List<VideoModel> videoList = videos.toList();

  bool _inoutShowing = false;

  var _barrageKey = GlobalKey<BarrageState>();

  @override
  void initState() {
    super.initState();
    //黑色状态栏，仅Android
    changeStatusBar(
        color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoModel;
    _loadDetail();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: Platform.isIOS,
          context: context,
          child: videoModel?.url != null
              ? Column(
            children: [
              //iOS 黑色状态栏
              NavigationBarPlus(
                color: Colors.black,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 46,
                child: Container(),
              ),
              _buildVideoView(),
              _buildTabNavigation(),
              Flexible(
                  child: TabBarView(
                    controller: _controller,
                    children: [
                      _buildDetailList(),
                      Container(
                        child: Text('敬请期待...'),
                      )
                    ],
                  ))
            ],
          )
              : Container()),
    );
  }

  _buildVideoView() {
    var model = videoModel;
    return VideoViewClass(
      model!.url!,
      cover: model.cover,
      overlayUI: videoAppBar(),
    );
  }

  _buildTabNavigation() {
    //使用Material实现阴影效果
    return Material(
      elevation: 5,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        height: 39,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            BarrageSwitch(onShowInput: () {
              setState(() {
                _inoutShowing = true;
              });
              HiOverlay.show(context, child: BarrageInput(
                onTabClose: () {
                  setState(() {
                    _inoutShowing = false;
                  });
                },
              )).then((value) {
                print('---input:$value');

                _barrageKey.currentState!.send(value!);
              });
            }, onBarrageSwitch: (open) {
              if (open) {
                _barrageKey.currentState!.play();
              } else {
                _barrageKey.currentState!.pause();
              }
            })
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return FwTab(
      tabs.map<Tab>((name) {
        return Tab(
          text: name,
        );
      }).toList(),
      controller: _controller,
    );
  }

  _buildDetailList() {
    return ListView(
      padding: EdgeInsets.all(0),
      children: [...buildContents(), ..._buildVideoList()],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel!.owner,
      ),
      ExpandableContent(mo: videoModel!),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel!,
        onLike: _doLike,
        onUnLike: _onUnLike,
        onFavorite: _onFavorite,
      )
    ];
  }

  void _loadDetail() async {}

  ///点赞
  _doLike() async {}

  ///取消点赞
  void _onUnLike() {}

  ///收藏
  void _onFavorite() async {}

  _buildVideoList() {
    return videoList
        .map((VideoModel mo) => VideoLargeCard(videoModel: mo))
        .toList();
  }
}
