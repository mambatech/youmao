/// date : 2020/3/29 
/// created by william yuan

import 'GlobalPlayState.dart';
import 'action.dart';

List<dynamic> combinLyric (String source) {
  List<dynamic> outputLyric = [];
  source.split('[').forEach((item) {
    List<String> splitItem = item.split('');
    // 需要保证歌词进度是正确的格式
    bool isAccess = true;
    try {
      int.parse(splitItem[0] + splitItem[1]);
    } catch (err) {
      isAccess = false;
    }
    if (isAccess) {
      outputLyric.add(item.split(']'));
    }
  });
  return outputLyric;
}


GlobalPlayState playStateReducer(GlobalPlayState state, action) {

  if(action != null) {
    var type = action['type'];
    print('william-----------------------> action $type');
    if( type == Actions.nextSong || type == Actions.prevSong || type == Actions.addPlayList) {
      var co =  action['payload']['coverMainColor'];
      state.coverMainColor = co;
    }
    if(action['type'] == Actions.addPlayList) {
      if (state.playing) {
        state.audioPlayer.stop();
        state.playing = false;
      }
      if (action['payload']['songList'] != null) {
        state.songList = action['payload']['songList'];
      }
      if (action['payload']['songDetail']['songLyr']['lrc'] != null && action['payload']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        action['payload']['songDetail']['lyric'] = combinLyric(action['payload']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.songIndex = action['payload']['songIndex'];
      state.playList.add(action['payload']['songDetail']);
      state.currentIndex = state.playList.length - 1;
      state.songUrl = action['payload']['songUrl'];
      state.audioPlayer.play(state.songUrl);
      state.playing = true;
    }
    else {

    }
  }
  //TODO action相关操作
  return state;
}