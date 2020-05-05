import 'package:flutter/material.dart';
import 'package:youmao/model/DailyModel.dart';
import 'package:youmao/utils/router.dart';

class WikiSubjectPage extends StatefulWidget {
  List<DailyModelItem> datas;
  String title;

  WikiSubjectPage(this.title, this.datas);

  @override
  State<StatefulWidget> createState() {
    return WikiSubjectState();
  }
}

class WikiSubjectState extends State<WikiSubjectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: widget.datas.length,
            itemBuilder: (BuildContext context, int index) =>
                _listTile(widget.datas[index], index, context),
            separatorBuilder: (BuildContext context, int index) =>
                const Divider()));
  }
}

ListTile _listTile(DailyModelItem modelItem, int index, BuildContext context) =>
    ListTile(
      title: Row(
        children: <Widget>[
          Expanded(
            child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Text(modelItem.summary,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      letterSpacing: 0.5,
                      fontSize: 14,
                    ))),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              modelItem.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
      onTap: () {
        Navigator.pushNamed(context, RouteNames.WIKI_WEB, arguments: modelItem);
      },
    );
