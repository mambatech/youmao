import 'package:flutter/material.dart';
import 'package:youmao/page/Album/albumDetail.dart';
import 'package:youmao/page/play.dart';
import 'package:youmao/page/webview_page.dart';

import '../home.dart';

class RouteNames {
  static const String POLICY_PRIVACY = 'policy_privacy';
  static const String USER_PRIVACY = 'users_privacy';
  static const String HOME_WIDGET = 'home_widget';
  static const String ALBUM_DETAIL = 'album_detail';
  static const String PLAY = 'play';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.POLICY_PRIVACY:
        return MaterialPageRoute(
            settings: RouteSettings(name: RouteNames.POLICY_PRIVACY),
            builder: (context) => CustomBrowser(
                "http://45.32.39.163/chongai_privacy.html",
                settings.arguments));
        break;
      case RouteNames.USER_PRIVACY:
        return MaterialPageRoute(
            settings: RouteSettings(name: RouteNames.USER_PRIVACY),
            builder: (context) => CustomBrowser(
                "http://45.32.39.163/chongai_user.html",
                settings.arguments));
        break;
      case RouteNames.HOME_WIDGET:
        return MaterialPageRoute(
            settings: RouteSettings(name: RouteNames.HOME_WIDGET),
            builder: (context){
              return new HomeManagerWidget(settings.arguments);
            });
        break;
      case RouteNames.ALBUM_DETAIL:
        return MaterialPageRoute(
            builder: (context) {
              return AlbumDetail(settings.arguments);
            }
        );
        break;
      case RouteNames.PLAY:
        return MaterialPageRoute(
            builder: (context) => Play()
        );
        break;
    }
  }
}
