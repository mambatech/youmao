import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:youmao/model/model.dart';
import 'package:youmao/redux/GlobalAppState.dart';
import 'package:youmao/redux/common/state.dart';
import 'package:youmao/redux/play/GlobalPlayState.dart';
import 'package:youmao/splashscreen.dart';
import 'home_page.dart';
import 'music_page.dart';
import 'soud_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:redux/redux.dart';

void main() {
  final globalStore = Store<GlobalAppState>(appReducer, middleware: [thunkMiddleware], initialState: GlobalAppState(
    commonState: CommonState.initState(),
    globalPlayState: GlobalPlayState.initState(),
  ));
  runApp(MyApp(globalStore));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Store<GlobalAppState> globalStore;
  MyApp(this.globalStore);
  @override
  Widget build(BuildContext context) {

    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.greenAccent,
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
            home: new SplashScreen(globalStore),
          ),
        );
      },
    );

  }
}

