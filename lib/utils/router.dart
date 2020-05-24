import 'package:flutter/material.dart';
import 'package:youmao/model/DailyModel.dart';
import 'package:youmao/page/Album/albumDetail.dart';
import 'package:youmao/page/WikiSubjectPage.dart';
import 'package:youmao/page/play.dart';
import 'package:youmao/page/webview_page.dart';

import '../home.dart';

class RouteNames {
  static const String POLICY_PRIVACY = 'policy_privacy';
  static const String USER_PRIVACY = 'users_privacy';
  static const String HOME_WIDGET = 'home_widget';
  static const String ALBUM_DETAIL = 'album_detail';
  static const String PLAY = 'play';
  static const String WIKI_WEB = 'wiki_web';
  static const String WIKI_SUBJECT_LIST = 'wiki_subject_list';
}

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.POLICY_PRIVACY:
        return MaterialPageRoute(
            settings: RouteSettings(name: RouteNames.POLICY_PRIVACY),
            builder: (context) => CustomBrowser(
                "http://fivelovelypets.com/chongai_privacy.html",
                settings.arguments,false));
        break;
      case RouteNames.USER_PRIVACY:
        return MaterialPageRoute(
            settings: RouteSettings(name: RouteNames.USER_PRIVACY),
            builder: (context) => CustomBrowser(
                "http://fivelovelypets.com/chongai_user.html",
                settings.arguments,false));
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
      case RouteNames.WIKI_WEB:
        if (settings.arguments is DailyModelItem) {
          DailyModelItem data = settings.arguments as DailyModelItem;

          return MaterialPageRoute(
              settings: RouteSettings(name: RouteNames.WIKI_WEB),
              builder: (context) =>
                  CustomBrowser(
                      data.url,
                      data.summary,true));
        }
        break;
      case RouteNames.WIKI_SUBJECT_LIST:
        if(settings.arguments is DailyModel){
          DailyModel data = settings.arguments as DailyModel;
          return MaterialPageRoute(
              settings: RouteSettings(name: RouteNames.WIKI_SUBJECT_LIST),
              builder: (context){
                return new WikiSubjectPage(data.name,data.contentData);
              });
        }
        break;
    }
  }
}
