import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:youmao/model/model.dart';
import 'package:youmao/splashscreen.dart';
import 'home_page.dart';
import 'music_page.dart';
import 'soud_page.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
            home: new SplashScreen(),
          ),
        );
      },
    );

    /**return MaterialApp(
      title: '友猫',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
      ),
      home: BottomNavigationBarWidget(),
    );**/
  }
}
/**
class BottomNavigationBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BottomNavigationBarWidgetState();
  }
}
class BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  int mSelectedIndex = 0;
  List<Widget> mItemList = List();
  @override
  void initState() {
    super.initState();
    mItemList..add(HomePage('首页'))..add(MusicPage('音乐'))..add(SoundPage('模仿'));
  }

  void onClick(int index) {
    setState(() {
      mSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: mItemList[mSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), title: Text('音乐')),
          BottomNavigationBarItem(icon: Icon(Icons.surround_sound),title: Text('模仿')),
        ],
        currentIndex: mSelectedIndex,
        selectedItemColor: Colors.teal,
        onTap: onClick,
      ),
    );
  }


}**/

