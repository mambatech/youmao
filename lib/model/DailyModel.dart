// To parse this JSON data, do
//
//     final dailyModel = dailyModelFromJson(jsonString);

import 'dart:convert';

List<DailyModel> dailyModelFromJson(String str) => List<DailyModel>.from(json.decode(str).map((x) => DailyModel.fromJson(x)));

String dailyModelToJson(List<DailyModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DailyModel {
  String name;
  List<DailyItemModel> contentData;

  DailyModel({
    this.name,
    this.contentData,
  });

  factory DailyModel.fromJson(Map<String, dynamic> json) => DailyModel(
    name: json["name"],
    contentData: List<DailyItemModel>.from(json["content_data"].map((x) => DailyItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "content_data": List<dynamic>.from(contentData.map((x) => x.toJson())),
  };
}

class DailyItemModel {
  String url;
  String summary;
  String image;

  DailyItemModel({
    this.url,
    this.summary,
    this.image,
  });

  factory DailyItemModel.fromJson(Map<String, dynamic> json) => DailyItemModel(
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
