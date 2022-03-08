class UserModel {
  String? uId;
  String? name;
  String? email;
  String? phone;
  bool? isVerified;

  UserModel(
      {this.uId,
      this.name,
      this.email,
      this.phone,

      this.isVerified});

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];

    isVerified = json['isVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'phone': phone,

      'isVerified': isVerified,
    };
  }
}
