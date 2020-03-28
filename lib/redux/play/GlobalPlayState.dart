/// date : 2020/3/29
/// created by william yuan
/// 播放器状态控制器

class GlobalPlayState {

  // 已经播放过或者正在添加的歌曲数组（包含歌曲详细信息）
  List _playList;
  get playList => _playList;

  //初始化
  GlobalPlayState.initState() {
    _playList = [];
  }

  GlobalPlayState(this._playList);

}