
import 'package:flutter/material.dart';
import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

class AppAnalysis extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (previousRoute != null && previousRoute.settings != null &&
        previousRoute.settings.name != null) {
      print("umeng...didPush_end:${previousRoute.settings.name}");
      UmengAnalyticsPlugin.pageEnd(previousRoute.settings.name);
    }

    if (route != null && route.settings != null && route.settings.name != null) {
      print("umeng...didPush_start:${route.settings.name}");
      UmengAnalyticsPlugin.pageStart(route.settings.name);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    if (route != null && route.settings != null && route.settings.name != null) {
      print("umeng...didPop_end:${route.settings.name}");
      UmengAnalyticsPlugin.pageEnd(route.settings.name);
    }

    if (previousRoute != null && previousRoute.settings != null &&
        previousRoute.settings.name != null) {
      print("umeng...didPop_start:${previousRoute.settings.name}");
      UmengAnalyticsPlugin.pageStart(previousRoute.settings.name);
    }
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    if (oldRoute != null && oldRoute.settings != null && oldRoute.settings.name != null) {
      print("umeng...didReplace_end:${oldRoute.settings.name}");
      UmengAnalyticsPlugin.pageEnd(oldRoute.settings.name);
    }

    if (newRoute != null && newRoute.settings != null && newRoute.settings.name != null) {
      print("umeng...didReplace_start:${newRoute.settings.name}");
      UmengAnalyticsPlugin.pageStart(newRoute.settings.name);
    }
  }
}