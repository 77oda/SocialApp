import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel{
  List<NotifyModel> data =[];

  NotificationModel.fromJson(List json) {
    json.forEach((element) {
      data!.add(NotifyModel.fromJson(element));
    });
  }
}


class NotifyModel
{
  String? type;
  String? comment;
  String? uId;
  String? image;
  String? dateTime;
  String? name;
  String? postId;

  NotifyModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.comment,
    this.postId,
    this.type
  });

  NotifyModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    comment = json['comment'];
    postId = json['postId'];
    type = json['type'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'comment':comment,
      'postId':postId,
      'type':type
    };
  }
}