/// date : 2020/3/29 
/// created by william yuan
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:youmao/utils/api.dart';
import 'package:youmao/utils/commonFetch.dart';

enum Actions {
  pause,
  play,
  nextSong,
  prevSong,
  addPlayList,
  playSeek,
  next,
  switchSongComments,
  addCollectSong,
  deleteCollectSong,
  changeProgress
}

ThunkAction<GlobalAppState> playNextSong = (Store<GlobalAppState> store) async {
  Map _songListActionPayload = new Map();
  dynamic state = store.state.globalPlayState;
  Map songDetail = {};
  dynamic _songListAction = new Map();
  if (state.currentIndex < state.playList.length - 1) {
    List<int> coverMainColor = await getColorFromUrl(state.playList[state.currentIndex + 1]['al']['picUrl']);
    _songListActionPayload['coverMainColor'] = coverMainColor;
    _songListAction['payload'] = _songListActionPayload;
    _songListAction['type'] = Actions.nextSong;
    store.dispatch(_songListAction);
    return;
  }
  dynamic songLyr = await getData('lyric', {
    'id': state.songList[state.songIndex + 1]
  });
  if (state.songList.length == state.songIndex + 1) {
    songDetail = await getSongDetail(int.parse(state.songList[0]));
    _songListActionPayload['songIndex'] = 0;
    _songListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[0] + '.mp3';
  } else {
    songDetail = await getSongDetail(int.parse(state.songList[state.songIndex + 1]));
    _songListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex + 1] + '.mp3';
  }
  songDetail['songLyr'] = songLyr;
  _songListActionPayload['songDetail'] = songDetail;
  List<int> coverMainColor = await getColorFromUrl(songDetail['al']['picUrl']);
  _songListActionPayload['coverMainColor'] = coverMainColor;
  _songListAction['payload'] = _songListActionPayload;
  _songListAction['type'] = Actions.nextSong;
  store.dispatch(_songListAction);
};

ThunkAction<GlobalAppState> playePrevSong = (Store<GlobalAppState> store) async {
  Map _songListActionPayload = new Map();
  dynamic state = store.state.globalPlayState;
  Map songDetail = {};
  dynamic _songListAction = new Map();
  if (state.songIndex - 1 < 0) {
    store.state.commonState.toastMessage = '没有上一曲了~';
    store.state.commonState.toastStatus = true;
  }
  dynamic songLyr = await getData('lyric', {
    'id': state.songList[state.songIndex - 1]
  });
  songDetail = await getSongDetail(int.parse(state.songList[state.songIndex - 1]));
  _songListActionPayload['songUrl'] = 'http://music.163.com/song/media/outer/url?id=' + state.songList[state.songIndex - 1] + '.mp3';
  songDetail['songLyr'] = songLyr;
  _songListActionPayload['songDetail'] = songDetail;
  List<int> coverMainColor = await getColorFromUrl(songDetail['al']['picUrl']);
  _songListActionPayload['coverMainColor'] = coverMainColor;
  _songListAction['payload'] = _songListActionPayload;
  _songListAction['type'] = Actions.prevSong;
  store.dispatch(_songListAction);
};

ThunkAction<GlobalAppState> addPlayList (action) {
  print('william ---------------> addPlayList Action');
  return (Store<GlobalAppState> store) async {
    List<int> coverMainColor = await getColorFromUrl(action['payload']['songDetail']['al']['picUrl']);
    action['payload']['coverMainColor'] = coverMainColor;
    store.dispatch(action);
  };
}