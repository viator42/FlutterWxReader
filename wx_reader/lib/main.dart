import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globle.dart' as globle;
import 'view/mainpage.dart';
import 'utils/static_values.dart' as staticValues;
import 'package:wx_reader/model/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() {
    _loadConfig();

    globle.dio = Dio();
    globle.dio.options
      ..baseUrl = staticValues.serverPath
      ..connectTimeout = 5000 //5s
      ..receiveTimeout = 5000
      ..validateStatus = (int status) {
        return status > 0;
      };

  }

  _loadConfig() async {
    //获取登录信息
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userStr = prefs.getString('user');
      if(userStr != null && !userStr.isEmpty) {
        var data = jsonDecode(userStr);
        globle.user = User.fromJson(data);
      }

    }catch(exception) {
      print(exception.toString());
    }

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
