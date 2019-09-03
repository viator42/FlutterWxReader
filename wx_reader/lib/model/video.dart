class Video {
  int id;
  String title;
  String brief;
  String cover;
  String url;

  Video({this.id, this.title, this.brief, this.cover, this.url});

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      brief: json['brief'],
      cover: json['cover'],
      url: json['url'],
    );
  }

}