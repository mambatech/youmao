/// date : 2020/3/29 
/// created by william yuan

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youmao/page/PlayList.dart';


class RecommendList extends StatelessWidget {
  final List recommendList;
  final String listTitle;
  final String des;

  RecommendList(this.recommendList, this.listTitle, this.des);

  //创建推荐列表的推荐item UI
  Widget createSongListRow (List<Map<String, dynamic>> rowData) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        itemCount: rowData.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                //print("william------------->onTap");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlayList(rowData[index]['id'])
                    )
                );
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: rowData[index]['coverImgUrl'] ?? rowData[index]['picUrl'],
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          padding: EdgeInsets.fromLTRB(0, 3, 5, 5),
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.black26, Colors.white24]
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: rowData[index]['playCount'] != null ? Text(
                            (rowData[index]['playCount'] / 10000).toStringAsFixed(0) + '万',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 11
                            ),
                          ) : null,
                        )
                      ],
                    ),
                    Container(
                      width: 100,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        rowData[index]['name'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 11
                        ),
                      ),
                    )
                  ],
                ),
              )
          );
        },
      ),
    );
  }

  List<Widget> createRecommendSongListRow () {
    List<Map<String, dynamic>> rowData = [];
    List<Widget> allRowData = [Container(
      padding: EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  listTitle,
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: 10,
                      fontWeight: FontWeight.w100
                  ),
                ),
              ),
              Container(
                child: Text(
                  des,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            child: Text(
              '查看更多',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.black54,
                  fontWeight: FontWeight.w100
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black12,
                    width: 1,
                    style: BorderStyle.solid
                ),
                borderRadius: BorderRadius.circular(7)
            ),
          )
        ],
      ),
    )];

    for(int i = 0;i < this.recommendList.length; i++) {
      rowData.add(this.recommendList[i]);
      if (this.recommendList.length <= i || i == 4) {
        allRowData.add(createSongListRow(rowData));
        return allRowData;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return recommendList == null
        ?
    Container()
        :
    Column(
        children: createRecommendSongListRow()
    );
  }
}