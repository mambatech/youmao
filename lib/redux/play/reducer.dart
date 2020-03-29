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
      print('william-----------------------> action $co');
    }
    if(action['type'] == Actions.addPlayList) {
      print('william-----------------------> action play');
      if (state.playing) {
        print('william-----------------------> action playing');
        state.audioPlayer.stop();
        state.playing = false;
      }
      if (action['payload']['songList'] != null) {
        print('william-----------------------> action ]songList != null');
        state.songList = action['payload']['songList'];
      }
      if (action['payload']['songDetail']['songLyr']['lrc'] != null && action['payload']['songDetail']['songLyr']['lrc']['lyric'] != null) {
        print('william-----------------------> action ]songsssssssfffff-------33434List != null');
        action['payload']['songDetail']['lyric'] = combinLyric(action['payload']['songDetail']['songLyr']['lrc']['lyric']);
      }
      state.songIndex = action['payload']['songIndex'];
      state.playList.add(action['payload']['songDetail']);
      state.currentIndex = state.playList.length - 1;
      state.songUrl = action['payload']['songUrl'];
      var songurl = state.songUrl;
      print('william-----------------------> action play $songurl');
      if(state.audioPlayer == null ) {
        print('william-----------------------> action state.audioPlayer == null');
      }
      state.audioPlayer.play(songurl);
      state.playing = true;
    }
    else {

    }
  }
  //TODO action相关操作
  return state;
}