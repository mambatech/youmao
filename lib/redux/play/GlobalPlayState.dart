import 'package:audioplayers/audioplayers.dart';

/// date : 2020/3/29
/// created by william yuan
/// 播放器状态控制器

class GlobalPlayState {

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  //第三方音乐播放器,用于音乐播放
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前所播放的歌曲长度
  Duration _duration;
  get duration => _duration;
  set duration(val) => _duration = val;

  //初始化
  GlobalPlayState.initState() {
    _playList = [];
    _audioPlayer = new AudioPlayer();
    // 监听当前歌曲长度
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
  }

  GlobalPlayState(this._playList, this._audioPlayer);

}