class MessageModel {
  String? senderId;
  String? receiverId;
  String? text;
  String? image;
  String? timeDate;

  MessageModel({
    this.senderId,
    this.receiverId,
    this.text,
    this.image,
    this.timeDate,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    text = json['text'];
    image = json['image'];
    timeDate = json['timeDate'];
  }
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'image': image,
      'timeDate': timeDate,
    };
  }
}
