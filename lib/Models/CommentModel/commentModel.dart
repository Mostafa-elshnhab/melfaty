class CommentModel {
  String? uId;
  String? name;
  String? commentImage;
  String? image;
  String? text;
  String? timeDate;

  CommentModel({
    this.uId,
    this.name,
    this.text,
    this.timeDate,
    this.commentImage,
    this.image,
  });

  CommentModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    text = json['text'];
    timeDate = json['timeDate'];
    image = json['image'];
    commentImage = json['commentImage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'text': text,
      'timeDate': timeDate,
      'image': image,
      'commentImage': commentImage,
    };
  }
}
