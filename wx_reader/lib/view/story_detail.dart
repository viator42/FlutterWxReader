import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/news.dart';
import 'package:flutter_html_view/flutter_html_view.dart';

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

  _load() async {
    setState(() {
      _isLoading = true;
    });
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(
          Uri.parse(serverPath + '/app/news/detail/?id=' + id.toString()));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      print(data['news']);
      setState(() {
        _isLoading = false;
        _news = News.fromJson(data['news']);
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