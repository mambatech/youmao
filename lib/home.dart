import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youmao/home_page.dart';
import 'package:youmao/music_page.dart';
import 'package:youmao/soud_page.dart';

class HomeManagerWidget extends StatefulWidget {

  HomeManagerWidget();
  final bottomItems = [
    new BottomItem("Home", Icons.home),
    new BottomItem("Music", Icons.library_music),
    new BottomItem("Sound", Icons.surround_sound),
  ];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeManagerState();
  }
}

class HomeManagerState extends State<HomeManagerWidget>with SingleTickerProviderStateMixin<HomeManagerWidget> {

  var mPages;
  int mCurrentIndex = 0;
  //默认
  String mTitle = "友猫";
  //TODO
  bool mIsLoading = false;
  final mPageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mPages = [HomePage("首页"), MusicPage("音乐咯"), SoundPage("声音")];
  }

  void onPageChanged(int index) {
    setState(() {
      mCurrentIndex = index;
    });
      mTitle = widget.bottomItems[index].title;
  }
  //底部item点击回调
  void onBottomTap(int index) {
    mPageController.jumpToPage(index);
    mTitle = widget.bottomItems[index].title;
  }

  GlobalKey<ScaffoldState> mScaffoldState = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var bottomOptions = <BottomNavigationBarItem>[];
    for (var i = 0; i < widget.bottomItems.length; i++) {
      var d = widget.bottomItems[i];
      bottomOptions.add(
        new BottomNavigationBarItem(icon: new Icon(d.icon,),
          title: new Text(d.title),
          backgroundColor: Theme.of(context).primaryColor,
        ),

      );
    }


    return new WillPopScope(child: new Scaffold(
      key: mScaffoldState,
      appBar: mCurrentIndex == 0 ? null:new AppBar(
        title: new Text(mTitle),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search), onPressed: () {
            //TODO 搜索点击
          })
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.play_circle_filled),
          onPressed: () {
            //TODO 播放器悬浮球点击
          }),
      drawer: new Drawer(
        //左边菜单栏
        child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(accountName: new Text(mTitle), accountEmail: null, currentAccountPicture: CircleAvatar(
            child: Image.asset("images/launch.png"),
            backgroundColor: Colors.white,
          ),),
          new Column(
            children: <Widget>[
              new ListTile(
                leading: new Icon(Icons.settings,
                color: Theme.of(context).accentColor,),
                title: new Text("Settings"),
                onTap: () {
                  //TODO 设置点击事件
                },
              ),
              new ListTile(
                leading: new Icon(Icons.info,
                color: Theme.of(context).accentColor,),
                title: new Text("About"),
                onTap: (){
                  //TODO about点击
                },
              ),
              Divider(),
              new ListTile(
                leading: Icon(Icons.share,
                color: Theme.of(context).accentColor,),
                title: Text("Share"),
                onTap: (){
                  //TODO
                },
              ),
            ],
          ),
        ],

      ),),
      body: mIsLoading?new Center(
        child: new CircularProgressIndicator(),
      )
      :Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: PageView(controller: mPageController,
        children: mPages,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics (),),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bottomOptions,
        onTap: onBottomTap,
        currentIndex: mCurrentIndex,
      ),
    ), onWillPop: _onWillPop);
  }

  //TODO 带
  Future<bool> _onWillPop() {
    if (mCurrentIndex != 0) {
      onBottomTap(0);
    } else {
      if (Platform.isAndroid) {
        if (Navigator.of(context).canPop()) {
          return Future.value(true);
        } else {
          const platform = const MethodChannel('android_app_retain');
          platform.invokeMethod("sendToBackground");
          return Future.value(false);
        }
      } else {
        return Future.value(true);
      }
    }


  }
}

class BottomItem {
  String title;
  IconData icon;
  BottomItem(this.title, this.icon);
}