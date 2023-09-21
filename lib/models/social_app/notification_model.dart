
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
}