import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'login.dart';
import 'package:wx_reader/globle.dart';
import 'package:wx_reader/utils/static_values.dart';
import 'profile_edit.dart';
import 'settings.dart';

class MinePage extends StatefulWidget {
  MinePage() : super(key: Key(Random().nextDouble().toString()));

  @override
  State<StatefulWidget> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  @override
  Widget build(BuildContext context) {
    return  CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            middle: Text('我的页面'),

            trailing: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => SettingsPage())
                );
              },
              child: Icon(Icons.settings),
            ),
        ),
        child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 80.0, 0, 0),
                  child: (user!=null)?
                  //已登录
                  Center(
                    child: Column(
                      children: <Widget>[
                        ClipOval(
                          child: SizedBox(
                            width: 80.0,
                            height: 80.0,
                            child: (user!=null)?
                              Image.network(serverPath + user.headimg,
                                fit: BoxFit.fill,
                              ):
                              Image.asset('static/img/ic_headimg.png',
                                fit: BoxFit.fill,
                              ),
                          ),
                        ),
                        Text((user!=null)?user.nickname:'新用户'),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => ProfileEditPage())
                            );
                          },
                          child: Text('编辑个人资料'),
                        ),

                      ],
                    ),
                  ):
                  //未登录
                  Center(
                    child: Padding(
                        padding: EdgeInsets.all(18.0),
                        child: CupertinoButton(
                            child: Text('登录'),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => LoginPage())
                            );
                          },
                        ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                sliver: SliverToBoxAdapter(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.equalizer),
                            title: Text('读书排行榜'),
                            subtitle: Text('第一名'),
                          ),
                          ListTile(
                            leading: Icon(Icons.remove_red_eye),
                            title: Text('关注'),
                            subtitle: Text('已关注0人'),
                          ),
                        ],
                      ),
                    )
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                sliver: SliverToBoxAdapter(
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.note),
                            title: Text('笔记'),
                            subtitle: Text('0条'),
                          ),
                          ListTile(
                            leading: Icon(Icons.book),
                            title: Text('书单'),
                            subtitle: Text('0本'),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            ]
        )
    );
  }

}