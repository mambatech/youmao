/**
 * create by william 2020/3/14
 */
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String mTitle;
  HomePage(this.mTitle);

  @override
  PageHomeState createState() {
    return PageHomeState();
  }
}

class PageHomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(widget.mTitle),),body: Center(child: Text(
      '${widget.mTitle}内容',
      style: TextStyle(fontSize:  20),
    )),);
  }
}