/// date : 2020/3/29 
/// created by william yuan

class CommonState {
  bool _isSplashShow;
  get isSplashShow => _isSplashShow;
  set isSplashShow(v) => _isSplashShow = v;

  //全局初始化
  CommonState.initState(){
    this._isSplashShow = true;
  }

  CommonState(this._isSplashShow);
}