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
import 'package:wx_reader/utils/common_utils.dart';

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
    print("initState");
    super.initState();

    _user = globle.user;
    if(_user != null) {
      _reload();
    }

  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies");
  }

  @override
  void didUpdateWidget(ShelfPage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("deactivate");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('书架'),
      ),
      body:(_user!=null&&_bookList.isNotEmpty)?
      CustomScrollView (
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(8.0),
              child: Text('我的收藏',
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
                  return Container(
                      child: GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return new Container(
                                height: 56.0,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                      child: RaisedButton(
                                        child: Text('从书架移除'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _removeBookShelfDialog(_bookList[index].id);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );

                        },
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => BookDetailsPage(id: _bookList[index].id))
                          ).then((_) {
                            _reload();
                          });
                        },
                        child: Card(
                          child: Column(
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
                      )
                  );
                },
              childCount: _bookList.length,
            ),
          ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CupertinoButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            fullscreenDialog: true,
                            builder: (context) => BookStorePage())
                    ).then((_) {
                      _reload();
                    });
                  },
                  color: Colors.blue,
                  child: Text('去书城'),
                ),
              ),
            ),
        ],
      ): _bookListEmpty(),

        /*
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
            CupertinoButton(
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
         */

    );
  }

  /**
   * 书架为空的时候
   */
  _bookListEmpty() {
    return Padding(
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
    );
  }

  /**
   * 读取书架列表
   */
  _reload() {
    _bookList.clear();
    _load();
  }

  _load() async {
    Response response = await globle.dio.get("/app/book/shelf/list/?userId=${_user.id}&page=0");
    if(response != null) {
      String dataStr = response.data;
      print('data: ' + dataStr);
      _set(dataStr);

    }
    else {
      CommonUtils.showToast("读取失败");
    }
  }

  /**
   * 移除书架
   */
  Future _removeFromBookShelf(int id) async {
    FormData formData = FormData.fromMap({
      "userId": _user.id,
      "bookId": id,
    });
    Response response = await globle.dio.post("/app/book/shelf/remove/",
        data: formData
    );
    if(response != null) {
      String dataStr = response.data;
      print(dataStr);
      var data = json.decode(dataStr);
      CommonUtils.showToast(data['msg']);
    }
    else {
      CommonUtils.showToast("移除失败");
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
      setState(() {
      });
      _nomoreData = true;
    }
  }

  Future<void> _removeBookShelfDialog(int id) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('确认'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("确定从书架中移除？")
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    _removeFromBookShelf(id).then((_) {
                      _reload();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('确定')),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消')),
            ],
          );
        }
    );
  }

}

