import 'package:flutter/material.dart';
import 'package:youmao/page/webview_page.dart';
import 'package:youmao/utils/router.dart';

class MePage extends StatefulWidget {
  String title;
  MePage(this.title);

  @override
  MePageState createState() {
    return MePageState(title);
  }
}

class MePageState extends State<MePage> {
  final List<String> entries = <String>['隐私协议','用户协议'];

  String title;
  MePageState(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: entries.length,
          itemBuilder: (BuildContext context, int index) => _listTile(entries[index],index,context),
          separatorBuilder: (BuildContext context, int index) => const Divider()),
    );
  }
}


ListTile _listTile(String titleStr,int index,BuildContext context) => ListTile(
      title: Text(titleStr,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          )),
      onTap: (){
        switch (index) {
          case 0 : //隐私协议
            Navigator.pushNamed(
                context,
                RouteNames.POLICY_PRIVACY,
                arguments: titleStr
            );
            break;
          case 1 : //用户协议
            Navigator.pushNamed(
                context,
                RouteNames.USER_PRIVACY,
                arguments: titleStr
            );
            break;
      }
      },
    );
