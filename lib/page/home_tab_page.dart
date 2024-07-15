import 'package:flutter/material.dart';

import '../api/profile.dart';
import '../api/video.dart';
import '../model/profile_mo.dart';
import '../model/video_model.dart';
import '../net/http/core/fw_error.dart';
import '../util/color.dart';
import '../util/toast.dart';
import '../widget/banner.dart';
import '../widget/video_card.dart';

class HomeTabPage extends StatefulWidget {
  final String name;
  final List<VideoModel> bannerList;
  int tid = 0;

  HomeTabPage(
      {Key? key,
      required this.name,
      required this.bannerList,
      required this.tid})
      : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<VideoModel> _videos = videos.toList();

  ScrollController _scrollController = ScrollController();
  int pageIndex = 1;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      print('dis:$dis');
      //当距离底部不足300时加载更多
      if (dis < 300 && !_loading) {
        print('------_loadData---');
        _loadData(tid: widget.tid, loadMore: true);
      }
    });
    _loadData(tid: widget.tid);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  ScrollController scrollController = ScrollController();

  @override
  get contentChild => ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom: 8), child: _banner()),
            GridView.builder(
              padding: EdgeInsets.all(0),
              //fix 不能一起滚动的问题
              physics: NeverScrollableScrollPhysics(),
              //fix嵌套滚动
              shrinkWrap: true,
              itemCount: _videos.length,
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoMo: _videos[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 0.82),
            ),
          ]);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: _loadData,
        color: primary,
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            // child: StaggeredGridView.countBuilder(
            //     controller: _scrollController,
            //     physics: const AlwaysScrollableScrollPhysics(),
            //     padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            //     crossAxisCount: 2,
            //     itemCount: _videos.length,
            //     itemBuilder: (BuildContext context, int index) {
            //       //有banner时第一个item位置显示banner
            //       if (widget.bannerList != null && index == 0) {
            //         return Padding(
            //             padding: EdgeInsets.only(bottom: 8), child: _banner());
            //       } else {
            //         return VideoCard(videoMo: _videos[index]);
            //       }
            //     },
            //     staggeredTileBuilder: (int index) {
            //       if (widget.bannerList != null && index == 0) {
            //         return StaggeredTile.fit(2);
            //       } else {
            //         return StaggeredTile.fit(1);
            //       }
            //       return StaggeredTile.fit(2);
            //     })));
            child: contentChild));
  }

  ProfileMo _profileMo = ProfileMo.fromJson(profiles);

  _banner() {
    return Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: FwBanner(_profileMo.bannerList));
  }

  Future<void> _loadData({int tid = 0, loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    try {
      List<VideoModel> homeDatas = videos.toList();
      setState(() {
        if (mounted) {
          //合并
          _videos = [..._videos, ...homeDatas];
          if (homeDatas != null) {
            pageIndex++;
          }
        }
      });
    } on NeedAuth catch (e) {
      print(e);
      showWarnToast(e.message);
    }
  }
}
