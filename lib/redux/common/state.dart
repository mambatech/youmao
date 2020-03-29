/// date : 2020/3/29 
/// created by william yuan

class CommonState {
  bool _isSplashShow;
  get isSplashShow => _isSplashShow;
  set isSplashShow(v) => _isSplashShow = v;

  bool _toastStatus;
  get toastStatus => _toastStatus;
  set toastStatus(v) => _toastStatus = v;

  String _toastMessage;
  get toastMessage => _toastMessage;
  set toastMessage(v) => _toastMessage = v;

  //全局初始化
  CommonState.initState(){
    this._isSplashShow = true;
    this._toastMessage = '';
    this._toastStatus = false;
  }

  CommonState(this._isSplashShow, this._toastMessage, this._toastStatus);
}