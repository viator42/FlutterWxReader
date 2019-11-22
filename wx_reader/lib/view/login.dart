import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wx_reader/utils/static_values.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wx_reader/model/user.dart';
import 'register.dart';
import 'package:wx_reader/globle.dart' as globle;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _telController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isShowingErrDialog = false;
  String errMsg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _telController.text = '17000000000';
    _passwordController.text = '123123';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return IndexedStack(
      children: <Widget>[

        Scaffold(
          appBar: CupertinoNavigationBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                  Icons.arrow_back_ios),
            ),
            middle: Text('登录'),
            trailing: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => RegisterPage())
                );
              },
              child: Text('注册'),
            ),
          ),
          body: Align(
            alignment: FractionalOffset(0.5, 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '手机号',
                    ),
                    controller: _telController,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '密码',
                    ),
                    obscureText: true,
                    controller: _passwordController,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed: () {
                        String tel = _telController.text;
                        String password = _passwordController.text;

                        if(tel == null || tel.isEmpty) {
                          setState(() {
                            errMsg = '手机号不能为空';
                            isShowingErrDialog = true;
                          });
                          return;
                        }
                        if(password == null || password.isEmpty) {
                          setState(() {
                            errMsg = '密码不能为空';
                            isShowingErrDialog = true;
                          });
                          return;
                        }

                        _doLogin(tel, password);
                      },
                      color: Colors.blue,
                      child: Text('登录'),
                    ),
                  ),
                )

              ],
            ),
          ),
        ),
        Opacity(
          opacity: isShowingErrDialog?1.0:0,
          child: CupertinoAlertDialog(
            title: Text('登录失败'),
            content: Text(errMsg),
            actions: <Widget>[
              CupertinoDialogAction(
                  onPressed: () {
                    setState(() {
                      isShowingErrDialog = false;
                    });
                  },
                  child: Text('好'))
            ],
          ),
        ),

      ],
    );
  }

  _doLogin(tel, password) async {
    try {
      var params = Map<String, String>();
      params["tel"] = tel;
      params["password"] = password;

      var client = http.Client();
      var response = await client.post(serverPath + '/app/user/login/', body: params);
      var data = jsonDecode(response.body);

      if(data['success']) {
        globle.user = User.fromJson(data['user']);

        //保存登录信息
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(data['user']));

        Navigator.pop(context);
      }
      else {
        setState(() {
          errMsg = data['msg'];
          isShowingErrDialog = true;
        });
      }
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }

  }

}