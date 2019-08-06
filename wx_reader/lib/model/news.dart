class News {
  int id;
  String title;
  String brief;
  String img;
  String content;

  News({this.id, this.title, this.brief, this.img, this.content});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      brief: json['brief'],
      img: json['img'],
      content: json['content'],
    );
  }

}