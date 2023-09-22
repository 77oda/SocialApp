class StoryModel
{
  String? name;
  String? uId;
  String? storyImage;
  String? dateTime;
  String? image;


  StoryModel({
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.storyImage
  });

  StoryModel.fromJson(Map<String, dynamic> json)
  {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    storyImage = json['storyImage'];
  }

  Map<String, dynamic> toMap()
  {
    return {
      'name':name,
      'uId':uId,
      'image':image,
      'dateTime':dateTime,
      'storyImage':storyImage
    };
  }
}