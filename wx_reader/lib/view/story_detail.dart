import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/news.dart';
import 'package:flutter_html_view/flutter_html_view.dart';
import 'package:wx_reader/globle.dart';

class StoryDetailPage extends StatefulWidget {
  int id;

  StoryDetailPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StoryDetailState(this.id);
  }
}

class _StoryDetailState extends State<StoryDetailPage> {
  int id;
  News _news;
  bool _isLoading = false;

  _StoryDetailState(this.id);

  _reload() {
    _load();
  }

  _load() async {
    String url = '/app/news/detail/?id=' + id.toString();

    setState(() {
      _isLoading = true;
    });

    mapCache.get(url).then((value){
      if(value != null && value.isNotEmpty) {
        _set(jsonDecode(value));
      }
      else {
        _loadFromWeb(url);
      }
    });

  }

  _loadFromWeb(String url) async {
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(
          Uri.parse(serverPath + url));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      mapCache.set(url, jsonEncode(data));
      _set(data);
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }
  }

  _set(var data) {
    setState(() {
      _isLoading = false;
      _news = News.fromJson(data['news']);
    });
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
        middle: Text('故事详情'),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: (_news!=null)?HtmlView(
              data: _news.content,
            ):null,
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