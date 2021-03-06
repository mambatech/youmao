import 'package:flutter/material.dart';
import 'package:youmao/utils/router.dart';

import 'model/DailyModel.dart';

class DailyPage extends StatefulWidget {
  String title;

  DailyPage(this.title);

  @override
  State<StatefulWidget> createState() {
    return DailyPageState();
  }
}

class DailyPageState extends State<DailyPage> {
  Future<String> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = DefaultAssetBundle.of(context)
        .loadString("assets/datas/daily_wiki_tag_and_feeds.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<String>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // 请求失败，显示错误
              return Text("加载失败请稍后重试...");
            } else {
              // 请求成功
              List<DailyModel> dailyDatas = dailyModelFromJson(snapshot.data);
              DailyModel recommendDailyMode;
              List<DailyModel> wikiDatas = [];
              dailyDatas.forEach((item) {
                if ("feeds" == item.type) {
                  recommendDailyMode = item;
                } else if ("tag" == item.type) {
                  wikiDatas.add(item);
                }
              });

              return Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                      padding: EdgeInsets.only(bottom: 20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return InkWell(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 27,
                                    backgroundColor:
                                        Color.fromARGB(255, 248, 187, 208),
                                    child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor:
                                            Color.fromARGB(0, 248, 187, 208),
                                        backgroundImage: AssetImage(
                                            wikiDatas[index].typeImage)),
                                  ),
                                  Text(
                                    wikiDatas[index].name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Roboto',
                                      letterSpacing: 0.5,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RouteNames.WIKI_SUBJECT_LIST,
                                    arguments: wikiDatas[index]);
                              },
                            );
                          },
                          childCount: wikiDatas.length,
                        ),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 100,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, RouteNames.WIKI_WEB,
                                arguments:
                                    recommendDailyMode.contentData[index]);
                          },
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        child: Text(
                                            recommendDailyMode
                                                .contentData[index].summary,
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
                                      recommendDailyMode
                                          .contentData[index].image,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],
                              ),
                              Divider(),
                            ],
                          ),
                        );
                      }, childCount: recommendDailyMode.contentData.length),
                    ),
                  ],
                ),
              );
            }
          } else {
            // 请求未结束，显示loading
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
