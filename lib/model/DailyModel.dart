// To parse this JSON data, do
//
//     final dailyModel = dailyModelFromJson(jsonString);

import 'dart:convert';

List<DailyModel> dailyModelFromJson(String str) => List<DailyModel>.from(json.decode(str).map((x) => DailyModel.fromJson(x)));

String dailyModelToJson(List<DailyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyModel {
  String name;
  String type;
  String typeImage;
  List<DailyModelItem> contentData;

  DailyModel({
    this.name,
    this.type,
    this.typeImage,
    this.contentData,
  });

  factory DailyModel.fromJson(Map<String, dynamic> json) => DailyModel(
    name: json["name"],
    type: json["type"],
    typeImage: json["type_image"],
    contentData: List<DailyModelItem>.from(json["content_data"].map((x) => DailyModelItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "type": type,
    "type_image": typeImage,
    "content_data": List<dynamic>.from(contentData.map((x) => x.toJson())),
  };
}

class DailyModelItem {
  String url;
  String summary;
  String image;

  DailyModelItem({
    this.url,
    this.summary,
    this.image,
  });

  factory DailyModelItem.fromJson(Map<String, dynamic> json) => DailyModelItem(
    url: json["url"],
    summary: json["summary"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "summary": summary,
    "image": image,
  };
}
