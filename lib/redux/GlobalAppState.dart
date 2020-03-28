import 'package:youmao/redux/common/reducer.dart';
import 'package:youmao/redux/common/state.dart';
import 'package:youmao/redux/play/GlobalPlayState.dart';
import 'package:youmao/redux/play/reducer.dart';

/// date : 2020/3/29 
/// created by william yuan
/// 全局变量控制

class GlobalAppState {

  GlobalPlayState globalPlayState;
  CommonState commonState;

  GlobalAppState({this.commonState, this.globalPlayState});
}

GlobalAppState appReducer(GlobalAppState state, action) {
  return GlobalAppState(
      commonState: commonReducer(state.commonState, action),
      globalPlayState:playStateReducer(state.globalPlayState, action),
  );
}
