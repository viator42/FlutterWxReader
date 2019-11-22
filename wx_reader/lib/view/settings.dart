import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/globle.dart' as globle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wx_reader/model/user.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsPageState();
  }

}

class SettingsPageState extends State<SettingsPage> {
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
        middle: Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          Divider(
            indent: 16.0,
            endIndent: 16.0,
            height: 1.5,
            color: Colors.black87,
          ),

          Padding(
            padding: EdgeInsets.all(8.0),
            child: FlatButton(
              color: Colors.redAccent,
              textColor: Colors.white,
              child: Text('退出登录'),
              onPressed: () {
                _doLogout();
              },
            ),
          ),

        ],
      ),
    );
  }

  _doLogout() async {
    globle.user = null;

    //删除登录信息
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    Navigator.pop(context);
  }

}