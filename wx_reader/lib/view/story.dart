import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/news.dart';
import 'package:wx_reader/utils/styles.dart';
import 'story_detail.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class StoryPage extends StatefulWidget {
  StoryPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<News> _newsList = [];
  bool _isLoading = false;
  bool _nomoreData = false;
  ScrollController scrollController = ScrollController();

  int _currentPage = 0;

  initState() {
    _reload();
  }

  _reload() {
    _nomoreData = false;
    _currentPage = 0;
    _newsList.clear();
    _load();
  }

  _load() async {
    setState(() {
      _isLoading = true;
    });
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + '/app/news/?page=$_currentPage'));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      print(data);

      setState(() {
        _isLoading = false;
      });

      List<News> appends = NewsList.fromJson(data).list;

      if(!appends.isEmpty) {
        setState(() {
          _newsList.addAll(appends);
          _currentPage += 1;
        });
      }
      else {
        _nomoreData = true;
      }

    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          middle: Text('故事')
      ),
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            RefreshIndicator(
              onRefresh: () {
                print('onRefresh');
              },
              child: LazyLoadScrollView(
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    builder: (context) => StoryDetailPage(_newsList[index].id)
                                ));
                          },
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      child: Text(_newsList[index].title,
                                        style: storyTitleTitleTextStyle,
                                      ),
                                      padding: EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                                    ),
                                  ),
                                  Padding(
                                    child: Image.network(serverPath + _newsList[index].img,
                                      fit: BoxFit.cover,
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                ],

                              ),
                              Divider(
                                indent: 8.0,
                                endIndent: 8.0,
                                height: 1.5,
                                color: Colors.black87,
                              ),
                            ],
                          ),
                        );
                      },
                      itemCount: _newsList.length),
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
        )
      ),
    );
  }

}

class NewsList {
  List<News> list;

  NewsList({this.list});

  factory NewsList.fromJson(List<dynamic> json) {
    List<News> list = json.map((i)=>News.fromJson(i)).toList();

    return NewsList(
        list: list
    );
  }

}
