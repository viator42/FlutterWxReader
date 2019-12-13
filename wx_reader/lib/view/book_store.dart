import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/styles.dart';
import 'book_details.dart';
import 'dart:convert';
import 'dart:io';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/book.dart';
import 'book_list.dart';
import 'package:wx_reader/globle.dart' as globle;

class BookStorePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookStoreState();
  }

}

class _BookStoreState extends State<BookStorePage> {
  List<Book> _recommendList;
  List<Category> _categoryList;
  List<Book> _guessYouLikeList;
  bool isLoading = false;

  _reload() {
    _load();
  }

  _load() async {
    setState(() {
      isLoading = true;
    });

    String categoryUrl = '/app/book/category/';
    String recommendUrl = '/app/book/recommend/';
    String guessYouLikeUrl = '/app/book/guessYouLike/';


    globle.mapCache.get(categoryUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setCategory(value);
      }
      else {
        _loadCategoryFromWeb(categoryUrl);
      }
    });

    globle.mapCache.get(recommendUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setRecommend(value);
      }
      else {
        _loadRecommendFromWeb(recommendUrl);
      }
    });

    globle.mapCache.get(guessYouLikeUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setGuessYouLike(value);
      }
      else {
        _loadGuessYouLikeFromWeb(guessYouLikeUrl);
      }
    });

  }

  _loadCategoryFromWeb(String url) async {
    Response response = await globle.dio.get(url);
    if(response != null) {
      String dataStr = response.data;
      print(dataStr);
      _setCategory(dataStr);
      globle.mapCache.set(url, dataStr);
    }

    /*
    var httpClient = HttpClient();
    var data = null;
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      data = jsonDecode(json);
      mapCache.set(url, jsonEncode(data));
      _setCategory(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }

     */
  }

  _setCategory(var dataStr) {
    var data = json.decode(dataStr);
    setState(() {
      isLoading = false;
      _categoryList = Category.decodeList(data);
    });
  }

  _loadRecommendFromWeb(String url) async {
    Response response = await globle.dio.get(url);
    if(response != null) {
      String dataStr = response.data;
      print(dataStr);
      _setRecommend(dataStr);
      globle.mapCache.set(url, dataStr);
    }
    /*
    var httpClient = HttpClient();
    var data = null;
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      data = jsonDecode(json);
      globle.mapCache.set(url, jsonEncode(data));
      _setRecommend(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
     */
  }

  _setRecommend(var dataStr) {
    var data = json.decode(dataStr);
    setState(() {
      isLoading = false;
      _recommendList = Book.decodeList(data);
    });
  }

  _loadGuessYouLikeFromWeb(String url) async {
    Response response = await globle.dio.get(url);
    if(response != null) {
      String dataStr = response.data;
      print(dataStr);
      _setGuessYouLike(dataStr);
      globle.mapCache.set(url, dataStr);
    }

    /*
    var httpClient = HttpClient();
    var data = null;
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      data = jsonDecode(json);
      globle.mapCache.set(url, jsonEncode(data));
      _setGuessYouLike(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
         */

  }

  _setGuessYouLike(var dataStr) {
    var data = json.decode(dataStr);
    setState(() {
      isLoading = false;
      _guessYouLikeList = Book.decodeList(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
              Icons.arrow_back_ios),
        ),
        middle: Text('书城'),
      ),
      child: Stack(
        children: <Widget>[
          (_categoryList!=null && _recommendList != null && _guessYouLikeList != null)?
          Padding(
            padding: EdgeInsets.fromLTRB(0, 65.0, 0, 0),
            child: CustomScrollView (
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Text('猜你喜欢',
                      style: categoryTextStyle,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverFixedExtentList(
                    itemExtent: 90.0,
                    delegate: SliverChildBuilderDelegate (
                            (BuildContext context, int index) {
                          return Card(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) => BookDetailsPage(id: _guessYouLikeList[index].id))
                                    );
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Image.network(serverPath + _guessYouLikeList[index].cover),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                                        child: Text(_guessYouLikeList[index].name),
                                      )

                                    ],
                                  ),
                                ),
                              )
                          );
                        },
                        childCount: _guessYouLikeList.length
                    ),
                  ),
                ),


                SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoButton(
                          child: Text('换一批'),
                          color: Colors.blue,
                          onPressed: () {
                          }),
                    )
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Text('热门推荐',
                      style: categoryTextStyle,
                    ),
                  ),
                ),

                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return SizedBox(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => BookDetailsPage(id: _recommendList[index].id))
                            );
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: Image.network(serverPath + _recommendList[index].cover,
                                    fit: BoxFit.fitWidth,
                                    height: 180.0,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                                  child: Center(
                                    child: Text(
                                      _recommendList[index].name,
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
                    childCount: _recommendList.length,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Text('分类',
                      style: categoryTextStyle,
                    ),
                  ),
                ),

                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                    childAspectRatio: 4.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => BookListPage(category: _categoryList[index].id, title: _categoryList[index].name))
                              );
                            },
                            child: Card(
                              child: Center(
                                child: Text(_categoryList[index].name),
                              ),
                            ),
                          )
                      );
                    },
                    childCount: _categoryList.length,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(16.0),
                    child: CupertinoButton(
                        color: Colors.blue,
                        child: Text('所有图书'),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => BookListPage(category: 0, title: '所有图书'))
                          );
                        }),
                  ),
                ),

              ],
            ),
          ): Opacity(
            opacity: isLoading? 1.0: 0.0,
            child: Center(
              child: CupertinoActivityIndicator(
                radius: 18.0,
                animating: isLoading,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class Category {
  int id;
  String name;
  String desp;

  Category({this.id, this.name, this.desp});

  static fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      desp: json['desp'],
    );
  }

  static List<Category> decodeList(var jsonData) {
    List<Category> categories = List<Category>();

    for(int i=0;i<jsonData.length; i++) {
      categories.add(fromJson(jsonData[i]));
    }

    return categories;
  }

}

/*
class CategoryList {
  List<Category> list = [];

  CategoryList({this.list});

  factory CategoryList.fromJson(List<dynamic> json) {
    List<Category> list = json.map((i)=>Category.fromJson(i)).toList();

    return new CategoryList(
        list: list
    );
  }
}

class RecommendList {
  List<Book> list = [];

  RecommendList({this.list});

  factory RecommendList.fromJson(List<dynamic> json) {
    List<Book> list = json.map((i)=>Book.fromJson(i)).toList();

    return new RecommendList(
        list: list
    );
  }
}

class GuessYouLikeList {
  List<Book> list = [];

  GuessYouLikeList({this.list});

  factory GuessYouLikeList.fromJson(List<dynamic> json) {
    List<Book> list = json.map((i)=>Book.fromJson(i)).toList();

    return new GuessYouLikeList(
        list: list
    );
  }
}
*/
