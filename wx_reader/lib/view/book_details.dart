import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/styles.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/book.dart';
import 'package:wx_reader/model/comment.dart';

class BookDetailsPage extends StatefulWidget {
  int id;

  BookDetailsPage({this.id});

  @override
  State<StatefulWidget> createState() {
    return _BookDetailsState(this.id);
  }

}

class _BookDetailsState extends State<BookDetailsPage> {
  int id;
  Book _book;
  BookCommentList _bookCommentList;

  _BookDetailsState(this.id);

  _load() async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(
          Uri.parse(serverPath + '/app/book/detail/?id=' + id.toString()));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      print(data['book']);
      setState(() {
        _book = Book.fromJson(data['book']);
      });

      request = await httpClient.getUrl(
          Uri.parse(serverPath + '/app/book/comment/?book=' + id.toString()));
      response = await request.close();

      json = await response.transform(utf8.decoder).join();
      data = jsonDecode(json);
      print(data);
      setState(() {
        _bookCommentList = BookCommentList.fromJson(data);
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
    print(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
              Icons.arrow_back_ios),
        ),
        middle: Text('书籍详情'),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: (_book!=null)?
                      Container(
                        height: 220.0,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Image.network(serverPath + _book.cover,
                                  fit: BoxFit.fitHeight,
                                  width: 80.0,
                                  height: 200.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 8.0, 8.0, 0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(_book.name,
                                      style: storyTitleTitleTextStyle,
                                      maxLines: 2,
                                    ),
                                    Text(
                                      _book.brief.length > 45?_book.brief.substring(0, 45):_book.brief,
                                      maxLines: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ):null,
                    ),
                    SliverToBoxAdapter(
                      child: ListTile(
                        leading: Text('轻点评分'),
                        title: Row(
                          children: <Widget>[
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                            Icon(Icons.star),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: (_book!=null)?
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Card (
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Baseline(
                                      baseline: 30.0,
                                      baselineType: TextBaseline.alphabetic,
                                      child: Text('￥' + _book.price.toString(),
                                        style: priceTextStyle,
                                      ),
                                    ),

                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Baseline(
                                      baseline: 30.0,
                                      baselineType: TextBaseline.alphabetic,
                                      child: Text('￥' + _book.originalPrice.toString(),
                                        style: originalPriceTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: FlatButton(
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  child: Text('立即购买'),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      ):null,
                    ),

                    SliverToBoxAdapter(
                      child: Container(
//                height: 180.0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 0),
                          child: Text('精彩点评',
                            style: storyTitleTitleTextStyle,
                          ),
                        ),
                      ),
                    ),
                    (_bookCommentList!=null && _bookCommentList.list.length > 0)?SliverPadding(
                      padding: EdgeInsets.all(8.0),
                      sliver: SliverFixedExtentList(
                        itemExtent: 140.0,
                        delegate: SliverChildBuilderDelegate (
                                (BuildContext context, int index) {
                              return Card(
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              ClipOval(
                                                child: SizedBox(
                                                  width: 36.0,
                                                  height: 36.0,
                                                  child: Image.network(serverPath + _bookCommentList.list[index].headimg,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
                                                child: Text(_bookCommentList.list[index].author,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                                                child: Text(
                                                    (_bookCommentList.list[index].content.length > 38)?
                                                    _bookCommentList.list[index].content.substring(0, 37) + '...':
                                                    _bookCommentList.list[index].content
                                                )

                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: <Widget>[
                                              Icon(Icons.star),
                                              Text(_bookCommentList.list[index].like.toString()),
                                            ],
                                          )
                                        ],
                                      )

                                  )
                              );
                            },
                            childCount: _bookCommentList.list.length
                        ),
                      ),
                    ):SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('当前还没有评论',
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              Container(
                height: 48.0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: FlatButton(onPressed: null, child: Text('添加到书架')),
                    ),
                    Expanded(
                      child: FlatButton(onPressed: null, child: Text('开始阅读')),
                    ),
                    Expanded(
                      child: FlatButton(onPressed: null, child: Text('下载')),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
      /*
      body:
      */
    );
  }

}

class BookCommentList {
  List<BookComment> list = [];

  BookCommentList({this.list});

  factory BookCommentList.fromJson(List<dynamic> json) {
    List<BookComment> list = json.map((i)=>BookComment.fromJson(i)).toList();

    return new BookCommentList(
        list: list
    );
  }
}
