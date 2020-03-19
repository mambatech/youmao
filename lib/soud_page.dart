/**
 * create by william 2020/3/14
 */

import 'package:flutter/material.dart';

class SoundPage extends StatefulWidget {
  String mTitle;

  SoundPage(this.mTitle);

  @override
  SoundPageState createState() {
    return SoundPageState();
  }
}
  class SoundPageState extends State<SoundPage> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(appBar: AppBar(title: Text(widget.mTitle),),body: Center(child: Text(
  '${widget.mTitle}内容',
  style: TextStyle(fontSize:  20),
  )),);
  }
}