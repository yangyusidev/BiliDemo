
import 'package:flutter_demo/widget/login_input.dart';
import 'package:flutter/material.dart';

import '../api/profile.dart';
import '../model/profile_mo.dart';
import '../theme/theme_provider.dart';
import 'package:provider/provider.dart';

import '../util/view_util.dart';
import '../widget/banner.dart';
import '../widget/benefit_card.dart';
import '../widget/blur.dart';
import '../widget/course_card.dart';
import '../widget/dark_mode_item.dart';
import '../widget/flexible_header.dart';

///我的
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  ProfileMo _profileMo = ProfileMo.fromJson(profiles);
  ScrollController _controller = ScrollController();

  static const double MAX_BOTTOM = 40;
  static const double MIN_BOTTOM = 10;
  //滚动范围
  static const MAX_OFFSET = 80;
  double _dyBottom = MAX_BOTTOM;

  // @override
  // void initState() {
  //   _controller.addListener(() {
  //     var offset = _controller.offset;
  //     //算出padding变化系数0-1
  //     var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
  //     //根据dyOffset算出具体的变化的padding值
  //     var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
  //     //临界值保护
  //     if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
  //       dy = MAX_BOTTOM - MIN_BOTTOM;
  //     } else if (dy < 0) {
  //       dy = 0;
  //     }
  //     setState(() {
  //       //算出实际的padding
  //       _dyBottom = MIN_BOTTOM + dy;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: NestedScrollView(
        controller: _controller,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_buildAppBar()];
        },
        body: ListView(
          padding: EdgeInsets.only(top: 10),
          children: [..._buildContentList()],
        ),
      ),
    );
  }

  _buildHead() {
    if (_profileMo == null) return Container();
    return FlexibleHeader(
        name: _profileMo.name, face: _profileMo.face, controller: _controller);
  }
  // _buildHead() {
  //   if (_profileMo == null) return Container();
  //   return Container(
  //     alignment: Alignment.bottomLeft,
  //     padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
  //     child: Row(
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(23),
  //           child: cachedImage(_profileMo.face, width: 46, height: 46),
  //         ),
  //         hiSpace(width: 8),
  //         Text(
  //           _profileMo.name,
  //           style: TextStyle(fontSize: 11),
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  bool get wantKeepAlive => true;

  _buildAppBar() {
    return SliverAppBar(
      //扩展高度
      expandedHeight: 160,
      //标题栏是否固定
      pinned: true,
      //定义股东空间
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        titlePadding: EdgeInsets.only(left: 0),
        title: _buildHead(),
        background: Stack(
          children: [
            Positioned.fill(
                child: cachedImage(
                    'https://www.devio.org/img/beauty_camera/beauty_camera4.jpg')),
            Positioned.fill(child: Blur(sigma: 20)),
            Positioned(bottom: 0, left: 0, right: 0, child: _buildProfileTab())
          ],
        ),
      ),
    );
  }

  _buildContentList() {
    if (_profileMo == null) {
      return [];
    }
    return [
      _buildBanner(),
      CourseCard(courseList: _profileMo!.courseList),
      BenefitCard(benefitList: _profileMo!.benefitList),
      DarkModelItem()
    ];
  }

  _buildBanner() {
    return FwBanner(_profileMo!.bannerList,
        bannerHeight: 120, padding: EdgeInsets.only(left: 10, right: 10));
  }

  _buildProfileTab() {
    if (_profileMo == null) return Container();
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      decoration: BoxDecoration(color: Colors.white54),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText('收藏', _profileMo!.favorite),
          _buildIconText('点赞', _profileMo!.like),
          _buildIconText('浏览', _profileMo!.browsing),
          _buildIconText('金币', _profileMo!.coin),
          _buildIconText('粉丝', _profileMo!.fans),
        ],
      ),
    );
  }

  _buildIconText(String text, int count) {
    return Column(
      children: [
        Text('$count', style: TextStyle(fontSize: 15, color: Colors.black87)),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
