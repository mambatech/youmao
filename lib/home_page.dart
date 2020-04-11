import 'dart:convert';

/**
 * create by william 2020/3/14
 */
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youmao/components/RecommedList.dart';
import 'package:youmao/components/customBottomNavigationBar.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/common/CommonActions.dart';
import 'components/HomeBanner.dart';
import 'components/RecommedSongs.dart';
import 'components/commonText.dart';

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
  List<dynamic> hotSongList;
  List<dynamic> popularCatSound;
  List<dynamic> basicList;
  List<dynamic> bannerList;
  List<dynamic> newList;

  //是否动态加载更新
  bool newSongsRequestOver = false;

  //翻页后保留tab状态
//  @override
//  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchBannerList();
      fetchRecommendSongList();
      fetchHotList();
      fetchCatSoundList();
      fetchNewList();
    });
  }

  void fetchBannerList() {
    Future<String> bannerString =
        DefaultAssetBundle.of(context).loadString("assets/datas/banner.json");
    bannerString.then((String value) {
      setState(() {
        dynamic jsonresult = jsonDecode(value);
//        print("william test json result -------- $jsonresult");
        bannerList = jsonresult['banners'];
      });
    });
  }

  void fetchHotList() {
    Future<String> hotstring =
        DefaultAssetBundle.of(context).loadString("assets/datas/hot.json");
    hotstring.then((String value) {
      setState(() {
        dynamic jsonresult = jsonDecode(value);
//          print("william test json result -------- $jsonresult");
      });
    });
  }

  void switchIsRequesting() {
    StoreProvider.of<GlobalAppState>(context)
        .dispatch(switchIsRequestingAction);
  }

  void fetchCatSoundList() async {
//    switchIsRequesting();
//    var _newSongs = await getData('newSongs', {});
//    switchIsRequesting();
    Future<String> catstring =
        DefaultAssetBundle.of(context).loadString("assets/datas/catsound.json");
    catstring.then((String value) {
      setState(() {
        dynamic jsonresult = jsonDecode(value);
//        print("william test json result -------- $jsonresult");
        basicList = jsonresult['playlists'];
        newSongsRequestOver = true;
      });
    });

//    if(_newSongs == '请求错误') {
//      return;
//    }
//    if(this.mounted) {
//      setState(() {
//        newSongs = _newSongs['result'];
////        newSongsRequestOver = true;
//      });
//    }
//    for (int i = 0;i < 9;i ++) {
//      fetchNewSongHotComments(_newSongs['result'], _newSongs['result'][i]['id'], i);
//    }
  }

  void fetchNewList() async {
    Future<String> newString =
        DefaultAssetBundle.of(context).loadString("assets/datas/new.json");
    newString.then((String value) {
      setState(() {
        dynamic jsonresult = jsonDecode(value);
//        print("william test json result -------- $jsonresult");
        newList = jsonresult['playlists'];
      });
    });
  }

  void fetchRecommendSongList() async {
    Future<String> hotString =
        DefaultAssetBundle.of(context).loadString("assets/datas/hot.json");
    hotString.then((String value) {
      setState(() {
        dynamic jsonresult = jsonDecode(value);
//        print("william test json result -------- $jsonresult");
        recommendSongList = jsonresult['playlists'];
      });
    });

////    switchIsRequesting();
//    var _hotSongList = await getData('hotPlaylist', {
//      'limit': '10',
//      'order': 'hot'
//    });
////    switchIsRequesting();
//    if (_hotSongList == 'response error') {
//      return;
//    }
//    if(this.mounted) {
//      setState(() {
//        this.recommendSongList = _hotSongList['playlists'];
//      });
//    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mTitle, style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
            ),
            //TODO 预设图片
            HomeBanner(bannerList),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  newSongsRequestOver
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            child: CommonText(
                                                '常用猫语',
                                                13,
                                                1,
                                                Colors.black,
                                                FontWeight.bold,
                                                TextAlign.start)),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                      child: new IconButton(
                                          icon:
                                              Icon(Icons.keyboard_arrow_right)),
                                    ),
                                  ],
                                )),
                            CatSongs(basicList, '最新流行歌曲')
                          ],
                        )
                      : Container(),
                  RecommendList(recommendSongList, '最热猫单', '最热流行猫曲'),
                  RecommendList(newList, '猫你喜欢', '最新猫猫单曲'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
