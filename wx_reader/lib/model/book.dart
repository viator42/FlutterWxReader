import 'dart:convert';

class Book {
  int id;
  String name;
  String author;
  double rank;
  int star;
  int fav;
  String brief;
  double originalPrice;
  double price;
  String content;
  int cateory;
  String cover;
  String ad;


  Book({this.id, this.name, this.author, this.rank, this.star, this.fav,
    this.brief, this.originalPrice, this.price, this.content, this.cateory, this.cover, this.ad});

  static fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      rank: json['rank'],
      star: json['star'],
      fav: json['fav'],
      brief: json['brief'],
      originalPrice: json['originalPrice'],
      price: json['price'],
      content: json['content'],
      cateory: json['cateory'],
      cover: json['cover'],
      ad: json['ad'],
    );
  }

  static List<Book> decodeList(var jsonData) {
    List<Book> books = List<Book>();

    for(int i=0;i<jsonData.length; i++) {
      books.add(fromJson(jsonData[i]));
    }

    return books;
  }

}