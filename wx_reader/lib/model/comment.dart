class BookComment {
  int id;
  String author;
  String headimg;
  String content;
  int like;
  int book;


  BookComment({this.id, this.author, this.headimg, this.content, this.like,
  this.book});

  factory BookComment.fromJson(Map<String, dynamic> json) {
    return BookComment(
        id: json['id'],
        author: json['author'],
        headimg: json['headimg'],
        content: json['content'],
        like: json['like'],
        book: json['book'],
    );
  }

}