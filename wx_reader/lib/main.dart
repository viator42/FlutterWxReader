import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globle.dart' as Globle;
import 'view/mainpage.dart';
import 'package:wx_reader/model/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    _loadConfig();
  }

  _loadConfig() async {
    //获取设置
//    String configStr = await _loadConfigObj();
//    print("configStr: " + configStr);
//    final configResponse = json.decode(configStr);
//    globle.serverPath = configResponse["serverPath"];

    //获取登录信息
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userStr = prefs.getString('user');
      if(userStr != null && !userStr.isEmpty) {
        var data = jsonDecode(userStr);
        Globle.user = User.fromJson(data);
      }

    }catch(exception) {
      print(exception.toString());
    }

  }

  Future<String> _loadConfigObj() async {
    return await rootBundle.loadString('static/json/config.json');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '微信读书',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainPage(),
    );
  }

}
