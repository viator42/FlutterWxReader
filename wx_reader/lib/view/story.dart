import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/common_utils.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/news.dart';
import 'package:wx_reader/utils/styles.dart';
import 'story_detail.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wx_reader/globle.dart' as globle;

class StoryPage extends StatefulWidget {
  StoryPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<News> _newsList = [];
  bool _isLoading = false;
  bool _nomoreDataNews = false;
  ScrollController scrollController = ScrollController();

  int _currentPageNews = 0;

  initState() {
    _reload();
  }

  _reload() {
    _nomoreDataNews = false;
    _currentPageNews = 0;
    _newsList.clear();
    _load();
  }

  _load() async {
    String newsUrl = '/app/news/?page=$_currentPageNews';

    setState(() {
      _isLoading = true;
    });

    globle.mapCache.get(newsUrl).then((value){
      if(value != null && value.isNotEmpty) {
        _setNews(value);
      }
      else {
        _loadNewsFromWeb(newsUrl);
      }
    });

  }

  _loadNewsFromWeb(String url) async {
    Response response = await globle.dio.get(url);
    if(response != null) {
      String dataStr = response.data;
      print('data: ' + dataStr);
      globle.mapCache.set(url, dataStr);
      _setNews(dataStr);

    }
    else {
      CommonUtils.showToast("读取失败");
    }
  }

  _setNews(String dataStr) {
    setState(() {
      _isLoading = false;
    });
    var data = json.decode(dataStr);
    List<News> appends = News.decodeList(data);

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('故事'),
        ),
        body: Center(
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
    );
  }

}
