import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/play/action.dart' as playControllerActions;

class Play extends StatefulWidget {
  @override
  PlayState createState() => new PlayState();
}

class PlayState extends State<Play> with SingleTickerProviderStateMixin {
  int songId;
  bool initPlay;
  bool showSongComments = false;
  dynamic songDetail;

  @override
  void initState() {
    super.initState();
    initPlay = false;
  }

  @override
  void dispose() {
    if(this.mounted) {
      super.dispose();
    }
  }

  void setInitPlay (bool val) {
    this.setState(() {
      initPlay = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalAppState, dynamic>(
      converter: (store) => store.state,
      builder: (BuildContext context, state) {
        return Material(
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(state.globalPlayState.coverMainColor[0], state.globalPlayState.coverMainColor[1],
                state.globalPlayState.coverMainColor[2], 1),
                      Colors.white
                    ]
                  )
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ProcessController(state),
                    PlayLyrics(),
                    PlayController(songId, state, setInitPlay),
                    // SongComments()
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: Colors.black87
                  ),
                ),
              ),
            ],
          )
        );
      }
    );
  }
}

class ProcessController extends StatefulWidget {
  final dynamic state;
  @override
  ProcessController(this.state);
  ProcessControllerState createState () => new ProcessControllerState(state);
}

class ProcessControllerState extends State<ProcessController> {
  dynamic state;
  String coverUrl;
  Color mainColor;
  ProcessControllerState(this.state);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalAppState, dynamic>(
      converter: (store) => store.state.globalPlayState,
      builder: (BuildContext context, globalPlayState) {
        return Container(
          child: Stack(
            children: <Widget>[
              // 之所以要把封面模块也写在进度条模块内是为了解决自动切换歌曲时不刷新封面视图的问题
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.2,
                MediaQuery.of(context).size.width * 0.3, 0, 0),
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow> [
                    BoxShadow(
                      color: Color.fromRGBO((globalPlayState.coverMainColor[0] / 5).round(), (globalPlayState.coverMainColor[1] / 5).round(),
              (globalPlayState.coverMainColor[2] / 5).round(), 0.3),
                      blurRadius: MediaQuery.of(context).size.width * 0.3,
                      spreadRadius: 5,
                      offset: Offset(0, 0)
                    )
                  ]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: state.globalPlayState.playList[state.globalPlayState.currentIndex]['al']['picUrl'],
                    placeholder: (context, url) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  )
                )
              ),
              Container(
                height: 70,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width - 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            state.globalPlayState.playList[state.globalPlayState.currentIndex ]['name'],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              state.globalPlayState.playList[state.globalPlayState.currentIndex ]['ar'][0]['name'],
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14
                              ),
                              textAlign: TextAlign.left,
                            )
                          )
                        ],
                      ),
                    ),
                  ],
                )
              )
            ],
          )
        );
      },
    );
  }
}

class PlayLyrics extends StatefulWidget {
  @override
  PlayLyricsState createState() => new PlayLyricsState();
}

class PlayLyricsState extends State<PlayLyrics> {
  // is touching process bar
  bool processTouching = false;
  double processVal = 0.0;
  Timer timer;
  // save&&dispatch playProcess
  Map durationActionMap = new Map();
  // swtich auto refresh view
  bool refreshView = true;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
       this.refreshView = !this.refreshView; 
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  double computeProcessVal(String position, String duration) {
    // current play percentage: 0.55555555
    double currentPercent = stringDurationToDouble(position) / stringDurationToDouble(duration); 
    if(!this.processTouching) {
      this.processVal = currentPercent * 500;
    }
    return currentPercent * 500;
  }

  double stringDurationToDouble (String duration) {
    return double.parse(duration.substring(0, 2)) * 60 + double.parse(duration.substring(3, 5));
  }
  
  List<String> getLyricsNow(List<dynamic> allLyrics, String timeNow, Duration allTime) {
    double _timeNow = stringDurationToDouble(timeNow);
    List<String> _lyricsNow = [];
    List<dynamic> _lyrics = [];
    if (allLyrics != null && allLyrics.length > 0) {
      allLyrics.forEach((item) {
        List<dynamic> _subLyrics = [];
        if (item.length != null && item.length == 2 && item[0] != null && item[1] != null) {
          if (item[0].length > 5) {
            _subLyrics.add(stringDurationToDouble(item[0].substring(0, 5)));
          } else {
            _subLyrics.add('');
          }
          _subLyrics.add(item[1]);
          _lyrics.add(_subLyrics);
        }
      });
    }
    for (int i = 0;i < _lyrics.length;i ++) {
      if (_timeNow >= _lyrics[i][0] && (i == _lyrics.length - 1 || _timeNow <= _lyrics[i + 1][0])) {
        _lyricsNow.add(i > 0 ? _lyrics[i - 1][1] : '');
        _lyricsNow.add(_lyrics[i][1]);
        _lyricsNow.add(i < _lyrics.length - 1 ? _lyrics[i + 1][1] : '');
      }
    }
    return _lyricsNow.length > 0
      ? _lyricsNow 
      : [
        '',
        '正在搜索歌词',
        ''
      ];
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalAppState, dynamic>(
      converter: (store) => store.state.globalPlayState,
      builder: (BuildContext context, globalPlayState) {
        return Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 25,
                      alignment: Alignment.topCenter,
                      child: Text(
                        globalPlayState.songProgress != null
                          ? this.getLyricsNow(globalPlayState.playList[globalPlayState.currentIndex ]['lyric'], globalPlayState.songProgress.toString().substring(2, 7), globalPlayState.duration)[0]
                          : '',
                        style: TextStyle(
                          color: Colors.black54
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 25,
                      alignment: Alignment.topCenter,
                      child: Text(
                        globalPlayState.songProgress != null
                          ? this.getLyricsNow(globalPlayState.playList[globalPlayState.currentIndex ]['lyric'], globalPlayState.songProgress.toString().substring(2, 7), globalPlayState.duration)[1]
                          : '',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 25,
                      alignment: Alignment.topCenter,
                      child: Text(
                        globalPlayState.songProgress != null
                          ? this.getLyricsNow(globalPlayState.playList[globalPlayState.currentIndex ]['lyric'], globalPlayState.songProgress.toString().substring(2, 7), globalPlayState.duration)[2]
                          : '',style: TextStyle(
                          color: Colors.black54,
                        ),
                        maxLines: 1,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Container(
                        width: 35,
                        child: Text(
                          globalPlayState.songProgress == null
                          ?
                          ''
                          :
                          globalPlayState.songProgress.toString().substring(2, 7),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11
                          ),
                        )
                      ),
                      StoreConnector<GlobalAppState, VoidCallback>(
                        converter: (store) {
                          return () => store.dispatch(durationActionMap);
                        },
                        builder: (BuildContext context, callback) {
                          return Container(
                            width: MediaQuery.of(context).size.width - 115,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: RoundSliderThumbShape(
                                  enabledThumbRadius: 4
                                ),
                                overlayShape: RoundSliderOverlayShape(
                                  overlayRadius: 8
                                )
                              ),
                              child: Slider(
                                value: processVal,
                                max: 500,
                                min: 0,
                                label: ((processVal.floor() / 500) * (int.parse(globalPlayState.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(globalPlayState.duration.toString().substring(5, 7))) / 60).floor().toString() + '：' +
                                  ((processVal.floor() / 500) * (int.parse(globalPlayState.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(globalPlayState.duration.toString().substring(5, 7))) % 60).floor().toString(),
                                activeColor: Color.fromRGBO((globalPlayState.coverMainColor[0] / 5).round(), (globalPlayState.coverMainColor[1] / 5).round(),
              (globalPlayState.coverMainColor[2] / 5).round(), 0.3),
                                inactiveColor: Colors.black26,
                                divisions: 500,
                                onChangeStart: (double val) {
                                  timer.cancel();
                                  processTouching = true;
                                },
                                onChanged: (double val) {
                                  setState(() {
                                    processVal = val; 
                                  });
                                },
                                onChangeEnd: (double val) async{
                                  int _songSecond = int.parse(globalPlayState.duration.toString().substring(2, 4)) * 60 +
                                  int.parse(globalPlayState.duration.toString().substring(5, 7));
                                  durationActionMap['type'] = playControllerActions.Actions.playSeek;
                                  durationActionMap['payload'] = Duration(milliseconds: (_songSecond * this.processVal.floor() * 2).round());
                                  callback();
                                  await new Future.delayed(const Duration(milliseconds: 500));
                                  processTouching = false;
                                  if (this.mounted) {
                                    setState(() {
                                      timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
                                        setState(() {
                                          refreshView = !refreshView; 
                                        });
                                      });
                                    });
                                  }
                                },
                              ),
                            )
                          );
                        },
                      ),
                      Text(
                        globalPlayState.songProgress != null
                          ?
                          computeProcessVal(globalPlayState.songProgress.toString().substring(2, 7), globalPlayState.duration.toString().substring(2, 7)).toString()
                          :
                          '',
                          style: TextStyle(
                            fontSize: 0
                          ),
                      ),
                      Container(
                        width: 35,
                        child: Text(
                          globalPlayState.duration == null
                          ?
                          ''
                          :
                          globalPlayState.duration.toString().substring(2, 7),
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 11
                          ),
                        )
                      )
                    ],
                  )
                )
              ],
            )
          )
        );
      });             
  }
}

class PlayController extends StatelessWidget {
  int songId;
  bool isRequesting = false;
  dynamic state;
  dynamic setInitPlay;
  dynamic songListAction;
  PlayController(this.songId, this.state, this.setInitPlay);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                var _action = new Map();
                _action['type'] = playControllerActions.Actions.addCollectSong;
                return () => store.dispatch(_action);
              },
              builder: (BuildContext context, callback) {
                return IconButton(
                  onPressed: () async {
                    callback();
                  },
                  icon: Icon(Icons.favorite, size: 20)
                );
              }
            ),
            StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playControllerActions.playePrevSong);
              },
              builder: (BuildContext context, callback) {
                return Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () async {
                      if (isRequesting == true) {
                        return null;
                      }
                      isRequesting = true;
                      await callback();
                      isRequesting = false;
                    },
                    icon: Icon(Icons.skip_previous, size: 30)
                  )
                );
              }
            ),
            StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                var _action = new Map();
                if (state.globalPlayState.playing == true) {
                  _action['type'] = playControllerActions.Actions.pause;
                } else {
                  _action['type'] = playControllerActions.Actions.play;
                }
                return () => store.dispatch(_action);
              },
              builder: (BuildContext context, callback) {
                return Material(
                  color: Color.fromRGBO(state.globalPlayState.coverMainColor[0], state.globalPlayState.coverMainColor[1],
          state.globalPlayState.coverMainColor[2], 0.3),
                  borderRadius: BorderRadius.circular(30),
                  child: IconButton(
                    iconSize: 35,
                    onPressed: () {
                      if(state.globalPlayState.playing != true) {
                        this.setInitPlay(true);
                      }
                      callback();
                    },
                    icon: 
                    state.globalPlayState.playing
                    ?
                      Icon(Icons.pause, size: 35)
                    :
                      Icon(Icons.play_arrow, size: 35)
                  )
                );
              }
            ),
            StoreConnector<GlobalAppState, VoidCallback>(
              converter: (store) {
                return () => store.dispatch(playControllerActions.playNextSong);
              },
              builder: (BuildContext context, callback) {
                return Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () async {
                      if (isRequesting == true) {
                        return null;
                      }
                      isRequesting = true;
                      await callback();
                      isRequesting = false;
                    },
                    icon: Icon(Icons.skip_next, size: 30)
                  )
                );
              }
            ),
            IconButton(
              onPressed: () async {
                print('暂未开发');
              },
              icon: Icon(Icons.loop, size: 20)
            )
          ],
        )
      );
  }
}