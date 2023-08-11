class PostModel
{
  String? name;
  String? uId;
  String? image;
  String? dateTime;
  String? time;
  String? text;
  String? postImage;
  String? postVideo;
  Map? likes;


  PostModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
    this.postVideo,
    this.time,
    this.likes
  });

  PostModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    time = json['time'];
    text = json['text'];
    postImage = json['postImage'];
    postVideo=json['postVideo'];
    likes=json['likes'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'time':time,
      'text':text,
      'postImage':postImage,
      'postVideo':postVideo,
      'likes':likes
    };
  }
}