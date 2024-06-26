import 'package:flutter/material.dart';
import 'package:flutter_demo/model/home_model.dart';
import 'package:flutter_demo/util/format_util.dart';
import 'package:flutter_demo/util/view_util.dart';

///视频卡片
class VideoCard extends StatelessWidget {
  HomeMo? model;

  VideoCard({super.key, this.model});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: SizedBox(
        height: 200,
        child: Card(
          margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_itemImage(context), _infoText()],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        cachedImage(model?.pic ?? "", width: size.width / 2 - 10, height: 120),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding:
                const EdgeInsets.only(left: 8, right: 8, bottom: 3, top: 5),
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black54, Colors.transparent])),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconText(Icons.ondemand_video, count: model?.aid ?? 0),
                _iconText(Icons.favorite_border, count: model?.favorites ?? 0),
                _iconText(null, duration: model?.duration),
              ],
            ),
          ),
        )
      ],
    );
  }

  _infoText() {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(top: 5, left: 8, right: 8, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            model?.title ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
          _owner()
        ],
      ),
    ));
  }

  _iconText(IconData? iconData, {int? count, String? duration}) {
    String views = "";
    if (iconData != null) {
      views = count != null ? countFormat(count) : "";
    } else {
      views = model?.duration ?? "00:00";
    }
    return Row(
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Text(
            views,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        )
      ],
    );
  }

  _owner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(model?.lastRecommend?.last.face ?? "",
                  height: 24, width: 24),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                model?.lastRecommend?.last.uname ?? "",
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            )
          ],
        ),
        const Icon(
          Icons.more_vert_sharp,
          size: 15,
          color: Colors.grey,
        )
      ],
    );
  }
}
