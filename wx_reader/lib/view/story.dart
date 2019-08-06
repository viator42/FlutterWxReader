import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'package:wx_reader/model/news.dart';
import 'book_details.dart';
import 'package:wx_reader/utils/styles.dart';
import 'story_detail.dart';

class StoryPage extends StatefulWidget {
  StoryPage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  List<News> _newsList = [];
  bool isLoading = false;
  ScrollController scrollController = ScrollController();

  initState() {
    _load();
  }

  _load() async {
    setState(() {
      isLoading = true;
    });
    var httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(serverPath + '/app/news/?page=0'));
      var response = await request.close();

      var json = await response.transform(utf8.decoder).join();
      var data = jsonDecode(json);
      print(data);
      setState(() {
        isLoading = false;
        _newsList = NewsList.fromJson(data).list;
      });

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
                        /*
                      child: Card(
                          child: Container(
                            height: 110.0,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                    left: 8.0,
                                    top: 8.0,
                                    width: 270.0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(_newsList[index].title,
                                          style: storyTitleTitleTextStyle,
                                        ),
                                      ],
                                    )
                                ),
                                Positioned(
                                  right: 8.0,
                                  top: 8.0,
                                  child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                    child: Image.network(serverPath + _newsList[index].img,
                                      fit: BoxFit.cover,
                                      width: 80.0,
                                      height: 80.0,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                      )*/
                    );
                  },
                  itemCount: _newsList.length),
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
