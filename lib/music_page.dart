/**
 * create by william 2020/3/14
 */

import 'package:flutter/material.dart';

class MusicPage extends StatefulWidget {
  String mTitle;

  MusicPage(this.mTitle);

  @override
  MusicPageState createState() {
    return MusicPageState();
  }
}
  class MusicPageState extends State<MusicPage> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title: Text(widget.mTitle),),body: Center(child: Text(
  '${widget.mTitle}内容',
  style: TextStyle(fontSize:  20),
  )),);
  }
}