class FollowModel{
  String? name;
  String? uId;
  String? image;

  FollowModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
  }
}