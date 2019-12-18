class News {
  int id;
  String title;
  String brief;
  String img;
  String content;

  News({this.id, this.title, this.brief, this.img, this.content});

  static fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      title: json['title'],
      brief: json['brief'],
      img: json['img'],
      content: json['content'],
    );
  }

  static List<News> decodeList(var jsonData) {
    List<News> books = List<News>();

    for(int i=0;i<jsonData.length; i++) {
      books.add(fromJson(jsonData[i]));
    }

    return books;
  }

}