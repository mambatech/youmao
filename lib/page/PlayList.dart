import 'package:cached_network_image/cached_network_image.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youmao/components/commonText.dart';
import 'package:youmao/components/customBottomNavigationBar.dart';
import 'package:youmao/redux/common/CommonActions.dart';
import 'package:youmao/utils/api.dart';
import 'package:youmao/utils/commonFetch.dart';
import './../redux/GlobalAppState.dart';
import 'package:youmao/redux/play/action.dart' as playControllerActions;

/// date : 2020/3/29
/// created by william yuan
/// 歌单列表页面

class PlayList extends StatefulWidget {

  final int id;
  PlayList(this.id):super();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print("william -----> PlayList createState");
    return new PlayListState(id);
  }
}

class PlayListState extends State<PlayList> {

  final int id;
  PlayListState(this.id);
  Map playListData;
  Color backgroundImageMainColor;
  dynamic playListAction;
  dynamic playList = [];
  bool isRequesting = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("william -----> PlayListState createState");
    //TODO 初始化playListData
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchOlayList(id);
    });
  }

  void fetchOlayList(id) async {
    switchIsRequesting();
    var _playListData = await getData('playlistDetail', {
      'id': id.toString()
    });
    switchIsRequesting();
    await getColorFromUrl(_playListData['playlist']['coverImgUrl']).then((palette) {
      backgroundImageMainColor = Color.fromRGBO(palette[0], palette[1],
          palette[2], 1);
    });
    if (_playListData == 'response error') {
      return;
    }
    if(this.mounted && _playListData != null) {
      setState(() {
        playListData = _playListData['playlist'];
      });
    }
  }

  void switchIsRequesting() {
    StoreProvider.of<GlobalAppState>(context).dispatch(switchIsRequestingAction);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<GlobalAppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Scaffold(
          bottomNavigationBar: CustomBottomNavigationBar(),
          body: playListData == null?
            Container(
              child: Center(
                child:SpinKitDoubleBounce(
                  color: Colors.green[300],
                )
              ),
            )
              :
          Material(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 270,
                    flexibleSpace: FlexibleSpaceBar(
                      background: PlayListCard(
                          playListData == null ? null : playListData['coverImgUrl'],
                          playListData == null ? null : playListData['name'],
                          playListData == null ? null : playListData['creator']['nickname'],
                          playListData == null ? null : playListData['tags'],
                          playListData == null ? null : playListData['description'],
                          backgroundImageMainColor
                      ),
                    ),
                    pinned: true,
                    backgroundColor: backgroundImageMainColor,
                  ),

                  SliverFixedExtentList(
                    itemExtent: 65,
                    delegate: SliverChildListDelegate(
                        createPlayListSongs(state)
                    ),

                  )
                ],
              )
          ),
        );
      },
    );
  }

  List<Widget> createPlayListSongs (state) {
    List<Widget> playListSongs = [];
    for (int index = 0;index < playListData.length; index++) {
      playListSongs.add(Container(
          child: StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playControllerActions.addPlayList(playListAction));
              },
              builder: (BuildContext context, callback) {
                return Material(
                    color: Colors.white,
                    child: Ink(
                        child: InkWell(
                            onTap: () async {
                              playListAction = {};
                              if (this.isRequesting == true) {
                                return null;
                              }

                              this.isRequesting = true;
                              switchIsRequesting();
                              dynamic songDetail = await getSongDetail(playListData['tracks'][index]['id']);
                              dynamic songLyr = await getData('lyric', {
                                'id': playListData['tracks'][index]['id'].toString()
                              });
                              switchIsRequesting();
                              Map _playListActionPayload = {};
                              List<String> _playList = [];
                              songDetail['songLyr'] = songLyr;
                              for(int j = 0;j < playListData['tracks'].length;j ++) {
                                _playList.add(playListData['tracks'][j]['id'].toString());
                              }
                              _playListActionPayload['songList'] = _playList;
                              _playListActionPayload['songIndex'] = index;
                              _playListActionPayload['songDetail'] = songDetail;
                              _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + playListData['tracks'][index]['id'].toString() + '.mp3';
                              playListAction['payload'] = _playListActionPayload;
                              playListAction['type'] = playControllerActions.Actions.addPlayList;
                              this.isRequesting = false;
                              print('william ----------> tap playlist detail $index');
                              callback();
                            },

                            child: Container(

                                margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                  children: <Widget>[
                                    state.globalPlayState.playList.length > 0 && state.globalPlayState.playList[state.globalPlayState.currentIndex] != null && state.globalPlayState.playList[state.globalPlayState.currentIndex]['id'] == playListData['tracks'][index]['id']
                                        ?
                                    Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 20,
                                        child: Image.asset('assets/images/playingAudio.png')
                                    )
                                        :
                                    Container(
                                      width: 30,
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width - 120,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Text(
                                              playListData['tracks'][index]['name'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 5),
                                            child: Text(
                                              playListData['tracks'][index]['ar'][0]['name'],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black54
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 20,
                                      child: Image.asset(
                                        'assets/images/more_playList.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    )
                                  ],
                                )
                            )
                        )
                    )
                );
              }
          )
      ));
    }
    return playListSongs;
  }
}

class PlayListCard extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;
  final String description;
  Color backgroundImageMainColor;
  final double blurHeight = 300;

  PlayListCard(this.backgroundImageUrl, this.title, this.creatorName, this.tags, this.description, this.backgroundImageMainColor);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: blurHeight,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundImageMainColor,
                    Colors.white
                  ]
              )
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(40, 80, 40, 0),
            child: Column(
              children: <Widget>[
                PlayListCardInfo(
                    this.backgroundImageUrl,
                    this.title,
                    this.creatorName,
                    this.tags,
                    this.description
                ),
                // PlayListCardButtons()
              ],
            )
        )
      ],
    );
  }
}

class PlayListCardInfo extends StatelessWidget {
  final String backgroundImageUrl;
  final String title;
  final String creatorName;
  final List<dynamic> tags;
  final String description;

  PlayListCardInfo(this.backgroundImageUrl, this.title, this.creatorName, this.tags, this.description);

  String composeTags(List<dynamic> list) {
    String _str = '';
    if (list.length == 0) {
      return '';
    }
    for(int i = 0;i < list.length;i ++) {
      _str = _str + list[i] + ' ';
    }
    return _str;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    imageUrl: this.backgroundImageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitWidth,
                    placeholder: (context, url) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 200,
                  margin: EdgeInsets.only(left: 15),
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CommonText(
                          this.title,
                          14,
                          2,
                          Colors.black87,
                          FontWeight.bold,
                          TextAlign.start
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: CommonText(
                            this.creatorName,
                            12,
                            1,
                            Colors.black87,
                            FontWeight.normal,
                            TextAlign.start
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          child: CommonText(
                              composeTags(this.tags),
                              12,
                              1,
                              Colors.black87,
                              FontWeight.normal,
                              TextAlign.start
                          )
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width - 60,
              constraints: BoxConstraints(
                  minHeight: 50
              ),
              margin: EdgeInsets.only(top: 20),
              child: CommonText(
                  description??'',
                  11,
                  3,
                  Colors.black87,
                  FontWeight.normal,
                  TextAlign.start
              ),
            ),
          ],
        )
    );
  }
}