class User {
  int id;
  String tel;
  String nickname;
  String headimg;
  String desp;
  String signing;

  User({this.id, this.tel, this.nickname, this.headimg, this.desp, this.signing});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      tel: json['tel'],
      nickname: json['nickname'],
      headimg: json['headimg'],
      desp: json['desp'],
      signing: json['signing'],
    );
  }

}