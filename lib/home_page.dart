/**
 * create by william 2020/3/14
 */
import 'package:flutter/material.dart';
import 'package:youmao/components/RecommedList.dart';
import 'package:youmao/utils/api.dart';

import 'components/HomeBanner.dart';

class HomePage extends StatefulWidget {
  String mTitle;
  HomePage(this.mTitle);

  @override
  PageHomeState createState() {
    return PageHomeState();
  }
}

class PageHomeState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  List<dynamic> recommendSongList;

  //翻页后保留tab状态
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchRecommendSongList();
    });
  }

  void fetchRecommendSongList() async {
//    switchIsRequesting();
    var _hotSongList = await getData('hotPlaylist', {
      'limit': '10',
      'order': 'hot'
    });
//    switchIsRequesting();
    if (_hotSongList == 'response error') {
      return;
    }
    if(this.mounted) {
      setState(() {
        this.recommendSongList = _hotSongList['playlists'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.mTitle),),body:
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //TODO 预设图片
            HomeBanner(null),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  Container(),
                  RecommendList(recommendSongList, '最热歌单', '最新流行歌单'),
                ],
              ),
            ),
          ],
        ),
    ),);
  }
}