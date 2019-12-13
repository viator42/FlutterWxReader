import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wx_reader/model/book.dart';
import 'package:wx_reader/model/user.dart';
import 'package:wx_reader/utils/styles.dart';
import 'book_details.dart';
import 'book_store.dart';
import 'package:wx_reader/globle.dart' as globle;
import 'package:wx_reader/utils/static_values.dart' as staticValues;
import 'dart:convert';

class ShelfPage extends StatefulWidget {
  ShelfPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  User _user;
  bool _isLoading = false;
  bool _nomoreData =false;
  int _currentPage = 0;
  List<Book> _bookList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _user = globle.user;
    if(_user != null) {
      _loadShelf();
    }

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('书架'),
      ),
        //判断是否登录
        child: (_user!=null)?
        Stack(
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
                              child: Image.network(staticValues.serverPath + _bookList[index].cover,
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
//                  _load();
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
        ):
        Padding(
            padding: EdgeInsets.fromLTRB(0, 48.0, 0, 0),
            child: Center(
              child: Container(
                width: 300.0,
                height: 160.0,
                child: Column(
                  children: <Widget>[
                    Text('重拾阅读的习惯\n为生活埋下微小的信仰',
                      style: plainTextStyle,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CupertinoButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => BookStorePage())
                          );
                        },
                        color: Colors.blue,
                        child: Text('去书城'),
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
    );
  }

  _loadShelf() async {
    Response response = await globle.dio.get("/app/book/shelf/list/?userId=${_user.id}&page=0");
    if(response != null) {
      String dataStr = response.data;
      print('data: ' + dataStr);
      _set(dataStr);

    }
    else {

    }
  }

  _set(String dataStr) {
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

}

