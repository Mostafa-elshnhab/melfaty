class PostModel {
  String? uId;
  String? name;
  String? postImage;
  String? image;
  String? text;
  String? timeDate;

  PostModel({
    this.uId,
    this.name,
    this.text,
    this.timeDate,
    this.postImage,
    this.image,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    text = json['text'];
    timeDate = json['timeDate'];
    image = json['image'];
    postImage = json['postImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'text': text,
      'timeDate': timeDate,
      'image': image,
      'postImage': postImage,
    };
  }
}
