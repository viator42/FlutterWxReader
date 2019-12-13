import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/book.dart';
import 'book_details.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wx_reader/globle.dart' as globle;

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
  bool _isLoading = false;
  bool _nomoreData =false;
  int _currentPage = 0;
  List<Book> _bookList = [];
  String title = '图书列表';

  _BookListPageState(this.category, this.title);

  _reload() {
    _nomoreData = false;
    _currentPage = 0;
    _bookList.clear();
    _load();
  }

  _load() {
    String url = '/app/book/category/books/?page=$_currentPage&category=$category';

    setState(() {
      _isLoading = true;
    });

    globle.mapCache.get(url).then((value){
      print('load from cache');
      if(value != null && value.isNotEmpty) {
        _set(value);
      }
      else {
        _loadFromWeb(url);
      }
    });

  }

  _loadFromWeb(String url) async {
    Response response = await globle.dio.get(url);
    if(response != null) {
      String dataStr = response.data;
      print(dataStr);
      _set(dataStr);
      globle.mapCache.set(url, dataStr);
    }

    /*
    var httpClient = HttpClient();
    try {
      var data = null;
      var request = await httpClient.getUrl(
          Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      data = jsonDecode(json);
      mapCache.set(url, jsonEncode(data));
      _set(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
     */
  }

  _set(var dataStr) {
    setState(() {
      _isLoading = false;
    });
    var data = json.decode(dataStr);
    List<Book> appends = Book.decodeList(data);

    if(!appends.isEmpty) {
      setState(() {
        _bookList.addAll(appends);
        _currentPage += 1;
      });
    }
    else {
      _nomoreData = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _reload();
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
      body: Stack(
        children: <Widget>[
          LazyLoadScrollView(
            child: (_bookList != null)? GridView.builder(
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
                            builder: (context) => BookDetailsPage(id: _bookList[index].id))
                    );
                  },
                  child: SizedBox(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Image.network(serverPath + _bookList[index].cover,
                              fit: BoxFit.fitWidth,
                              height: 180.0,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                            child: Center(
                              child: Text(
                                _bookList[index].name,
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
              itemCount: _bookList.length,
            ):null,

            onEndOfPage: () {
              print('load more page: $_currentPage');
              if(_nomoreData) {
                return;
              }
              if(!_isLoading) {
                _load();
              }
            },
          ),

          Opacity(
            opacity: _isLoading? 1.0: 0.0,
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 18.0,
                animating: _isLoading,
              ),
            ),
          ),

        ],
      ),
    );
  }

}
/*
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
 */