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
import 'package:wx_reader/globle.dart';
import 'package:wx_reader/model/video.dart';
import 'video_detail.dart';

class StoryPage extends StatefulWidget {
  StoryPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<News> _newsList = [];
  List<Video> _videoList = [];
  bool _isLoading = false;
  bool _nomoreDataNews = false;
  bool _nomoreDataVideo = false;
  ScrollController scrollController = ScrollController();

  int _currentPageNews = 0;
  int _currentPageVideo = 0;

  List<Tab> tabs = const <Tab>[
    Tab(text: '文章', icon: null),
    Tab(text: '视频', icon: null),
  ];

  List<Widget> tabContent;

  initState() {
    _reload();
  }

  _reload() {
    _nomoreDataNews = false;
    _nomoreDataVideo = false;
    _currentPageNews = 0;
    _currentPageVideo = 0;
    _newsList.clear();
    _load();
  }

  _load() async {
    String newsUrl = '/app/news/?page=$_currentPageNews';
    String videoUrl = '/app/video/?page=$_currentPageNews';

    setState(() {
      _isLoading = true;
    });

    mapCache.get(newsUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setNews(jsonDecode(value));
      }
      else {
        _loadNewsFromWeb(newsUrl);
      }
    });

    mapCache.get(videoUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setVideo(jsonDecode(value));
      }
      else {
        _loadVideoFromWeb(videoUrl);
      }
    });

  }

  _loadNewsFromWeb(String url) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      mapCache.set(url, jsonEncode(data));
      _setNews(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
  }

  _setNews(var data) {
    setState(() {
      _isLoading = false;
    });

    List<News> appends = NewsList.fromJson(data).list;

    if(!appends.isEmpty) {
      setState(() {
        _newsList.addAll(appends);
        _currentPageNews += 1;
      });
    }
    else {
      _nomoreDataNews = true;
    }
  }

  _loadVideoFromWeb(String url) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      mapCache.set(url, jsonEncode(data));
      _setVideo(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
  }

  _setVideo(var data) {
    setState(() {
      _isLoading = false;
    });

    List<Video> appends = VideoList.fromJson(data).list;

    if(!appends.isEmpty) {
      setState(() {
        _videoList.addAll(appends);
        _currentPageNews += 1;
      });
    }
    else {
      _nomoreDataVideo = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    tabContent = [
      Center(
        child: Stack(
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
                  print('load more page: $_currentPageNews');
                  if(_nomoreDataNews) {
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
        ),
      ),
      Center(
        child: Stack(
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
                                  builder: (context) => VideoDetailPage(_videoList[index])
                              ));
                        },
                        child: Stack(
                          children: <Widget>[
//                            Text(_videoList[index].title)
                            (_videoList != null)?
                            Image.network(serverPath + _videoList[index].cover,
                              fit: BoxFit.cover,
                            ):null,
                          ],
                        ),
                      );
                    },
                    itemCount: _videoList.length),
                onEndOfPage: () {
                  print('load more page: $_currentPageVideo');
                  if(_nomoreDataVideo) {
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
        ),
      ),

    ];

    // TODO: implement build
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
            middle: TabBar(
              labelColor: Colors.black87,
              tabs: tabs,
            ),
        ),
        body: TabBarView(
            children: tabContent,
        )
      ),
    );
  }

}

class TabChoice {
  const TabChoice({ this.title, this.icon });
  final String title;
  final IconData icon;
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

class VideoList {
  List<Video> list;

  VideoList({this.list});

  factory VideoList.fromJson(List<dynamic> json) {
    List<Video> list = json.map((i)=>Video.fromJson(i)).toList();

    return VideoList(
        list: list
    );
  }

}