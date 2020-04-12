import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';
import 'package:youmao/model/model.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/common/state.dart';
import 'package:youmao/redux/play/GlobalPlayState.dart';
import 'package:youmao/splashscreen.dart';
import 'dart:io';
import 'package:scoped_model/scoped_model.dart';
import 'package:redux/redux.dart';
import 'package:youmao/utils/AppAnalysis.dart';
import 'package:youmao/utils/router.dart';

void main() {
  final store = Store<GlobalAppState>(appReducer,
      middleware: [thunkMiddleware],
      initialState: GlobalAppState(
        commonState: CommonState.initState(),
        globalPlayState: GlobalPlayState.initState(),
      ));
  WidgetsFlutterBinding.ensureInitialized();
  umengInit();
  runApp(MyApp(store));
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

umengInit() async {
  UmengAnalyticsPlugin.init(
    androidKey: '5e92ab4f0cafb269c6000033',
    iosKey: '5e92ab89570df36f71000080',
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Store<GlobalAppState> globalStore;

  MyApp(this.globalStore);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
        store: globalStore,
        child: new DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => new ThemeData(
            primarySwatch: Colors.pink,
            accentColor: Colors.pinkAccent,
            fontFamily: 'Raleway',
            brightness: brightness,
          ),
          themedWidgetBuilder: (context, theme) {
            return ScopedModel<SongModel>(
              model: new SongModel(),
              child: new MaterialApp(
                title: '友猫',
                theme: theme,
                debugShowCheckedModeBanner: false,
                onGenerateRoute: Router.generateRoute,
                navigatorObservers: [AppAnalysis()],
                home: new SplashScreen(globalStore),
              ),
            );
          },
        ));
  }
}
