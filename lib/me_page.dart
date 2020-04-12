import 'package:flutter/material.dart';
import 'package:youmao/webview_page.dart';

class MePage extends StatefulWidget {
  String title;
  MePage(this.title);

  @override
  MePageState createState() {
    return MePageState();
  }
}

class MePageState extends State<MePage> {
  final List<String> entries = <String>['隐私协议','用户协议'];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) => _listTile(entries[index],index,context),
        separatorBuilder: (BuildContext context, int index) => const Divider());
  }
}


ListTile _listTile(String titleStr,int index,BuildContext context) => ListTile(
      title: Text(titleStr,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          )),
      onTap: (){
        switch(index){
          case 0 :   //隐私协议
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBrowser("http://45.32.39.163/chongai_privacy.html",titleStr)
                )
            );
            break;
      }
      },
    );
