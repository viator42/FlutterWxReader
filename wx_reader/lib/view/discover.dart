import 'dart:math';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/model/showcase.dart';
import 'package:wx_reader/utils/styles.dart';
import 'package:wx_reader/view/book_details.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/book.dart';
import 'package:wx_reader/globle.dart';
import 'package:wx_reader/globle.dart' as globle;

class DiscoverPage extends StatefulWidget {
  DiscoverPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  Pop _pop;
  List<Book> _recommendList;
  List<Showcase> _showcaseList;
  bool isLoading = false;

  initState() {
    _reload();
  }

  _reload() {
    _load();
  }

  _load() {
    String url = '/app/explorer/';

    setState(() {
      isLoading = true;
    });

    mapCache.get(url).then((value){
      print('load from cache');
      if(value != null && value.isNotEmpty) {
        _set(jsonDecode(value));
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
    }
    /*
    try {
      var data = null;
      var httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
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

  _set(String dataStr) {
    Map<String, dynamic> data = json.decode(dataStr);
    setState(() {
      isLoading = false;
      _pop = Pop.fromJson(data['pop']);
      _recommendList = Book.decodeList(data['recommend']);
      _showcaseList = Showcase.decodeList(data['showcase']);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Card(
          child: Stack(
            children: <Widget>[
              FractionallySizedBox(
                alignment: Alignment.center,
                widthFactor: 1.0,
                heightFactor: 1.0,
                child: (_pop != null)?Image.network(
                    serverPath + _pop.background,
                    fit: BoxFit.cover,
                ):Image.asset('static/img/dummy.png', fit: BoxFit.fill,)
              ),
              Positioned(
                top: 16.0,
                left: 16.0,
                child: Text((_pop != null)?_pop.title:"",
                  style: posterTitleTextStyle,
                ),
              ),

              Positioned(
                top: 48.0,
                left: 16.0,
                child: Text((_pop != null)?_pop.subtitle:"",
                  style: posterSubTitleTextStyle,
                ),
              ),

            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Text('为你推荐',
                  style: posterTitleTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                child: Text('根据你的阅读历史计算，每日更新',
                  style: posterSubTitleTextStyle,
                ),
              ),

              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Table(
                    columnWidths: <int, TableColumnWidth> {
                      0: FractionColumnWidth(0.5),
                      1: FractionColumnWidth(0.5),
                    },
                    children: <TableRow> [
                      TableRow(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => BookDetailsPage(id: _recommendList[0].id))
                              );
                            },
                            child: Container(
                              height: 210.0,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 170.0,

                                      child: (_recommendList != null)?Image.network(
                                        serverPath + _recommendList[0].cover,
                                        fit: BoxFit.fill,
                                        ):Image.asset('static/img/dummy.png', fit: BoxFit.fill,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                                      child: Text(
                                        (_recommendList != null)?
                                            _recommendList[0].name.length > 10?
                                              _recommendList[0].name.substring(0, 9) + '...':
                                              _recommendList[0].name
                                            :"",
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => BookDetailsPage(id: _recommendList[1].id))
                              );
                            },
                            child: Container(
                              height: 210.0,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 170.0,
                                      child: (_recommendList != null)?Image.network(
                                        serverPath + _recommendList[1].cover,
                                        fit: BoxFit.fill,
                                      ):Image.asset('static/img/dummy.png', fit: BoxFit.fill,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                                      child: Text(
                                        (_recommendList != null)?
                                        _recommendList[1].name.length > 10?
                                        _recommendList[1].name.substring(0, 9) + '...':
                                        _recommendList[1].name
                                            :"",
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      TableRow(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => BookDetailsPage(id: _recommendList[2].id))
                              );
                            },
                            child: Container(
                              height: 210.0,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 170.0,
                                      child: (_recommendList != null)?Image.network(
                                        serverPath + _recommendList[2].cover,
                                        fit: BoxFit.fill,
                                      ):Image.asset('static/img/dummy.png', fit: BoxFit.fill,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                                      child: Text(
                                        (_recommendList != null)?
                                        _recommendList[2].name.length > 10?
                                        _recommendList[2].name.substring(0, 9) + '...':
                                        _recommendList[2].name
                                            :"",
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                      fullscreenDialog: true,
                                      builder: (context) => BookDetailsPage(id: _recommendList[3].id))
                              );
                            },
                            child: Container(
                              height: 210.0,
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 170.0,
                                      child: (_recommendList != null)?Image.network(
                                        serverPath + _recommendList[3].cover,
                                        fit: BoxFit.fill,
                                      ):Image.asset('static/img/dummy.png', fit: BoxFit.fill,),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(0, 4.0, 0, 0),
                                      child: Text(
                                        (_recommendList != null)?
                                        _recommendList[3].name.length > 10?
                                        _recommendList[3].name.substring(0, 9) + '...':
                                        _recommendList[3].name
                                            :"",
                                      ),

                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
              ),
            ],
          ),

        ),
      ),

    ];

    if(_showcaseList != null) {
      for(Showcase showcase in _showcaseList) {
        pageList.add(Padding(
          padding: EdgeInsets.all(8.0),
          child: Card(
              child: Column(
                children: <Widget>[
                  Image.network(serverPath + showcase.banner,
                    fit: BoxFit.fill,
                    height: 260.0,
                  ),
                  ListTile(
                    leading: Image.network(
                      serverPath + showcase.leading,
                      width: 48.0,
                      height: 48.0,
                    ),
                    title: Text(showcase.title),
                    trailing: RaisedButton(
                      onPressed: () {
                      }, child: Text('领取')),
                    isThreeLine: false,
                  ),

                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                          showcase.trailing.length > 150?
                            showcase.trailing.substring(0, 150) + '...':
                            showcase.trailing
                      ),
                    ),
                  ),
                ],
              )
          ),
        ));
      }
    }

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text('探索'),
      ),
      body: Stack(
        children: <Widget>[
          DefaultTabController(
              length: pageList.length,
              child: TabBarView(children: pageList),
          ),
          Opacity(
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

class PageItem {
  const PageItem({this.title});
  final String title;
}

class Pop {
  String title = '';
  String subtitle = '';
  String background = '';
  String url = '';

  Pop({this.title, this.subtitle, this.background, this.url});

  static fromJson(Map<String, dynamic> json) {
    return Pop(
      title: json['title'],
      subtitle: json['subtitle'],
      background: json['background'],
      url: json['url'],
    );
  }

}

/*
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
*/


/*
class ShowcaseList {
  List<Showcase> list = [];

  ShowcaseList({this.list});

  factory ShowcaseList.fromJson(List<dynamic> json) {
    List<Showcase> list = json.map((i)=>Showcase.fromJson(i)).toList();

    return new ShowcaseList(
        list: list
    );
  }
}
*/