import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// date : 2020/3/29
/// created by william yuan
/// 播放器状态控制器

class GlobalPlayState {

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  // 已经播放过或者正要播放的歌曲索引
  var _currentIndex;
  get currentIndex => _currentIndex;
  set currentIndex(int val) => _currentIndex = val;

  // 当前正在播放的歌曲Url
  String _songUrl;
  get songUrl => _songUrl;
  set songUrl(val) => _songUrl = val;

  String _coverUrl;
  get coverUrl => _coverUrl;
  set coverUrl(val) => _coverUrl = val;

  String _name;
  get name => _name;
  set name(val) => _name = val;

  //第三方音乐播放器,用于音乐播放
  AudioPlayer _audioPlayer;
  get audioPlayer => _audioPlayer;

  // 当前所播放的歌曲封面主色调
  List<int> _coverMainColor;
  get coverMainColor => _coverMainColor;
  set coverMainColor(val) => _coverMainColor = val;

  // 当前所播放的歌曲长度
  Duration _duration;
  get duration => _duration;
  set duration(val) => _duration = val;

  // 当前是否正在播放歌曲
  bool _playing;
  get playing => _playing;
  set playing(val) => _playing = val;

  // 当前所播放的歌单（只包含歌曲Id）
  dynamic songList;

  // 当前所播放的歌单位置索引
  int _songIndex;
  get songIndex => _songIndex;
  set songIndex(val) => _songIndex = val;

  //初始化
  GlobalPlayState.initState() {
    _playList = [];
    _audioPlayer = new AudioPlayer();
    _coverMainColor = [0, 0, 0];
    _playing = false;
    // 监听当前歌曲长度
    _audioPlayer.onDurationChanged.listen((d) {
      duration = d;
    });
  }


  GlobalPlayState(this._playList, this._audioPlayer, this._coverMainColor, this._playing, this._currentIndex);
}