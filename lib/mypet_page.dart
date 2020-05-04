import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youmao/components/PetBanner.dart';
import 'package:youmao/model/model.dart';

/// date : 2020/4/19
/// created by william yuan

//宠物主页
class PetPage extends StatefulWidget {

  String mTitle;

  PetPage(this.mTitle);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PetPageState();
  }
}

class PetPageState extends State<PetPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mTitle, style: TextStyle(color: Colors.black),textAlign: TextAlign.center,),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
            ),
            //TODO 预设图片
            PetBanner(new Pet()),
          ],
        ),
      ),
    );
  }


}