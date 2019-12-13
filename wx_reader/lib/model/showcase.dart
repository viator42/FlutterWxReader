
import 'dart:convert';

class Showcase {
  String banner;
  String leading;
  String title;
  String subtitle;
  String trailing;

  Showcase({this.banner, this.leading, this.title, this.subtitle, this.trailing});

  static fromJson(Map<String, dynamic> json) {
    return Showcase(
      banner: json['banner'],
      leading: json['leading'],
      title: json['title'],
      subtitle: json['subtitle'],
      trailing: json['trailing'],
    );
  }

  static List<Showcase> decodeList(var jsonData) {
    List<Showcase> showcases = List<Showcase>();

    for(int i=0;i<jsonData.length; i++) {
      showcases.add(fromJson(jsonData[i]));
    }

    return showcases;
  }

}