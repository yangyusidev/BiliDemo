import 'package:flutter/material.dart';
import 'package:flutter_demo/core/fw_state.dart';
import 'package:flutter_demo/dao/home_dao.dart';
import 'package:flutter_demo/util/color.dart';
import 'package:flutter_demo/widget/banner.dart';
import 'package:flutter_demo/widget/video_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../model/home_model.dart';

class HomeTabPage extends StatefulWidget {
  HomeTabPage({super.key});

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends FwState<HomeTabPage> {
  ScrollController _scrollController = ScrollController();

  int pageIndex = 1;
  int pageSize = 10;
  List<HomeMo> data = [];

  @override
  void initState() {
    _scrollController.addListener(() {
      //你当前数据填充后的最大长度
      var dis = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (dis < 300) {
        print("小于300尺寸");
        _loadData(loadMore: true);
      }
    });
    _loadData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: StaggeredGridView.countBuilder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              crossAxisCount: 2,
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                //有banner时第一个item位置显示banner
                if (data != null && index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _banner(),
                  );
                } else {
                  return VideoCard(
                    model: data[index],
                  );
                }
              },
              staggeredTileBuilder: (int index) {
                if (data != null && index == 0) {
                  return const StaggeredTile.fit(2);
                } else {
                  return const StaggeredTile.fit(1);
                }
              })),
    );
  }

  _banner() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: FwBanner(data.sublist(0, 5)),
    );
  }

  ///loadMore 是否加载
  Future<void> _loadData({loadMore = false}) async {
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    List<HomeMo> homeData = await HomeDao.loadHomeRecommend(0,
        pageSize: pageSize, pageIndex: currentIndex);
    setState(() {
      data = [...data, ...homeData];
      if (homeData.isNotEmpty) {
        pageIndex++;
      }
    });
  }
}
