import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/common/CommonActions.dart';
import '../components/commonText.dart';
import 'package:youmao/redux/play/action.dart' as playControllerActions;
import 'package:path_provider/path_provider.dart';


//首页播放列表
class CatSongs extends StatelessWidget {
  final songs;
  final String title;
  CatSongs(this.songs, this.title);
  
  @override
  Widget build(BuildContext context) {
    return songs == null
    ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      color: Colors.grey,
    )
    :
    Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return CatSongsColumn(songs[index]);
        },
        itemCount: songs.length,
        control: SwiperControl(
          iconNext: null,
          iconPrevious: null
        ),
        loop: false
      )
    );
  }
}

class CatSongsColumn extends StatelessWidget {
  final songsColumn;
  final Map playListAction = {};

  CatSongsColumn(this.songsColumn);

  void switchIsRequesting(context) {
    StoreProvider.of<GlobalAppState>(context).dispatch(switchIsRequestingAction);
  }

  List<Widget> createRecommendSongsColumn (context) {
    List<Widget> recommendSongsColumn = [];
    print("william -------------> $songsColumn");
    for (int i = 0;i < songsColumn.length;i ++) {
      Map song = songsColumn[i];
      print("william -------------> $song");
      Container recommendSongsSingle = Container(
        margin: EdgeInsets.fromLTRB(20, 3, 20, 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
//                    child: CachedNetworkImage(
//                      imageUrl: song['coverImgUrl'],
//                      width: 50,
//                      height: 50,
//                      fit: BoxFit.cover,
//                      placeholder: (context, url) => Container(
//                        width: 50,
//                        height: 50,
//                        color: Colors.grey,
//                      ),
//                    ),
                      child: Image.asset(song['coverImgUrl'], height:50, width: 50, fit: BoxFit.cover,),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: CommonText(
                                  song['name'],
                                  13,
                                  1,
                                  Colors.black87,
                                  FontWeight.bold,
                                  TextAlign.start
                                )
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: CommonText(
                                  "",
                                  11,
                                  1,
                                  Colors.black54,
                                  FontWeight.normal,
                                  TextAlign.start
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  )
                ],
              ),
            ),
            StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playControllerActions.addPlayList(playListAction));
              },
              builder: (BuildContext context, callback) {
                return IconButton(
                  onPressed: () async {
                    switchIsRequesting(context);
//                    dynamic songDetail = await getSongDetail(song['id']);
//                    dynamic songLyr = await getData('lyric', {
//                      'id': song['id'].toString()
//                    });
                    switchIsRequesting(context);
                    Map _playListActionPayload = {};
                    List<String> _playList = [];
//                    songDetail['songLyr'] = songLyr;
                    _playList.add(song['id'].toString());
                    _playListActionPayload['songList'] = _playList;
                    _playListActionPayload['songIndex'] = 0;
//                    _playListActionPayload['songDetail'] = 100;
                    _playListActionPayload['coverImgUrl'] = song['coverImgUrl'];
//                    _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + song['id'].toString() + '.mp3';
                    _playListActionPayload['songUrl'] = song['fileUrl'];
                    _playListActionPayload['localplay'] = true;
                    _playListActionPayload['name'] = song['name'];

                    localPlay(song['id'].toString(), song['fileUrl'], context).then((String value){
                      _playListActionPayload['songUrl'] = value;
                      playListAction['payload'] = _playListActionPayload;
                      playListAction['type'] = playControllerActions.Actions.addPlayList;
                      callback();
                    });

                  },
                  icon: Icon(
                    Icons.play_arrow,
                    size: 20,
                  ),
                );
              }
            )
          ],
        ),
      );
      recommendSongsColumn.add(recommendSongsSingle);
    }
    return recommendSongsColumn;
  }

  Future<ByteData> loadAsset(String path, BuildContext context) async {
    return await DefaultAssetBundle.of(context).load(path);
  }

  Future<String> localPlay(String id, String path, BuildContext context) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/cat$id.mp3');
    final bytes = await loadAsset(path, context);
    await file.writeAsBytes(bytes.buffer.asUint8List());
//    print('william ---------nishuonexxxxxx--${file.path}');
    return file.path;
//    final result = await audioPlayer.play(file.path, isLocal: true);
  }



  Widget build(BuildContext context) {
    return Column(
      children: createRecommendSongsColumn(context)
    );
  }
}