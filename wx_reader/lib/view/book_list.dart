import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/book.dart';
import 'book_details.dart';

class BookListPage extends StatefulWidget {
  int category;
  String title;

  BookListPage({this.category, this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookListPageState(this.category, this.title);
  }

}

class _BookListPageState extends State<BookListPage> {
  int category;
  int page = 0;
  BookList _bookList;
  String title = '图书列表';

  _BookListPageState(this.category, this.title);

  _load() async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(
          Uri.parse(serverPath + '/app/book/category/books/?page=' + page.toString() + '&category=' + category.toString()));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      print(data);
      setState(() {
        _bookList = BookList.fromJson(data);
      });

    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
              Icons.arrow_back_ios),
        ),
        middle: Text(title),
      ),
      body: (_bookList != null)? GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => BookDetailsPage(id: _bookList.list[index].id))
              );
            },
            child: SizedBox(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Image.network(serverPath + _bookList.list[index].cover,
                        fit: BoxFit.fitWidth,
                        height: 180.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                      child: Center(
                        child: Text(
                          _bookList.list[index].name,
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: _bookList.list.length,
      ):null,
    );
  }

}

class BookList {
  List<Book> list = [];

  BookList({this.list});

  factory BookList.fromJson(List<dynamic> json) {
    List<Book> list = json.map((i)=>Book.fromJson(i)).toList();

    return new BookList(
        list: list
    );
  }
}