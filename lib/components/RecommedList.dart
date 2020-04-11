import 'dart:typed_data';

/// date : 2020/3/29
/// created by william yuan
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:youmao/page/PlayList.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/play/action.dart' as playControllerActions;
import 'package:path_provider/path_provider.dart';

class RecommendList extends StatelessWidget {
  final List recommendList;
  final String listTitle;
  final String des;
  final Map playListAction = {};

  RecommendList(this.recommendList, this.listTitle, this.des);

  //创建推荐列表的推荐item UI
  Widget createSongListRow(List<dynamic> rowData) {
    return StoreConnector<GlobalAppState, VoidCallback>(converter: (store) {
      return () =>
          store.dispatch(playControllerActions.addPlayList(playListAction));
    }, builder: (BuildContext context, callback) {
      return SizedBox(
        height: 170,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          itemCount: rowData.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: () {
//                  print("william------------->播放吧onTap");
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => PlayList(rowData[index]['id'])
//                    )
//                );
                //取消原有调整详情页，直接播放
                  Map _playListActionPayload = {};
                  List<String> _playList = [];
//                    songDetail['songLyr'] = songLyr;
                  _playList.add(rowData[index]['id'].toString());
                  _playListActionPayload['songList'] = _playList;
                  _playListActionPayload['songIndex'] = 0;
//                    _playListActionPayload['songDetail'] = 100;
                  _playListActionPayload['coverImgUrl'] =
                      rowData[index]['coverImgUrl'];
//                    _playListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + song['id'].toString() + '.mp3';
                  _playListActionPayload['songUrl'] = rowData[index]['fileUrl'];
                  _playListActionPayload['localplay'] = true;

                  localPlay(rowData[index]['id'].toString(),
                          rowData[index]['fileUrl'], context)
                      .then((String value) {
                    _playListActionPayload['songUrl'] = value;
                    playListAction['payload'] = _playListActionPayload;
                    playListAction['type'] =
                        playControllerActions.Actions.addPlayList;
                    callback();
                  });
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
//                            child: CachedNetworkImage(
//                              imageUrl: rowData[index]['coverImgUrl'] ?? rowData[index]['picUrl'],
//                              width: 100,
//                              height: 100,
//                              fit: BoxFit.cover,
//                              placeholder: (context, url) => Container(
//                                width: 100,
//                                height: 100,
//                                color: Colors.grey,
//                              ),
//                            ),
                              child: Image.asset(
                                rowData[index]['coverImgUrl'],
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.fromLTRB(0, 3, 5, 5),
                            alignment: Alignment.topRight,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.black26, Colors.white24]),
                                borderRadius: BorderRadius.circular(10)),
//                          child: rowData[index]['playCount'] != null ? Text(
//                            (rowData[index]['playCount'] / 10000).toStringAsFixed(0) + '万',
//                            textAlign: TextAlign.right,
//                            style: TextStyle(
//                                color: Colors.grey[200],
//                                fontSize: 11
//                            ),
//                          ) : null,
                          )
                        ],
                      ),
                      Container(
                        width: 100,
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          rowData[index]['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 11),
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
      );
    });
  }

  List<Widget> createRecommendSongListRow() {
    final rowData = [];
    //使用list去承载整个滑动ui
    List<Widget> allRowData = [
      Container(
        padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    listTitle,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 10,
                        fontWeight: FontWeight.w100),
                  ),
                ),
                Container(
                  child: Text(
                    des,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
//查看更多按钮取消
//            Container(
//              padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
//              child: Text(
//              '查看更多',
//                style: TextStyle(
//                    fontSize: 10,
//                    color: Colors.black54,
//                    fontWeight: FontWeight.w100),
//              ),
//              decoration: BoxDecoration(
//                  border: Border.all(
//                      color: Colors.black12,
//                      width: 1,
//                      style: BorderStyle.solid),
//                  borderRadius: BorderRadius.circular(7)),
//            )
          ],
        ),
      )
    ];
    for (int i = 0; i < this.recommendList.length; i++) {
      rowData.add(this.recommendList[i]);
      if (this.recommendList.length <= i || i == 3) {
        allRowData.add(createSongListRow(rowData));
        return allRowData;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return recommendList == null
        ? Container()
        : Column(children: createRecommendSongListRow());
  }

  Future<ByteData> loadAsset(String path, BuildContext context) async {
    return await DefaultAssetBundle.of(context).load(path);
  }

  Future<String> localPlay(String id, String path, BuildContext context) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/hot$id.mp3');
    final bytes = await loadAsset(path, context);
    await file.writeAsBytes(bytes.buffer.asUint8List());
//    print('william ---------nishuonexxxxxx--${file.path}');
    return file.path;
//    final result = await audioPlayer.play(file.path, isLocal: true);
  }
}
