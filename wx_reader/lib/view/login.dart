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
                  child: Container(
                    height: 42,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: '手机号',
                      ),
                      controller: _telController,
                    ),
                  ),

                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(80.0, 8.0, 80.0, 8.0),
                  child: Container(
                    height: 42,
                    child: TextField(
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: '密码',
                      ),
                      obscureText: true,
                      controller: _passwordController,
                    ),
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
                            _showErrDialog('手机号不能为空');
                          });
                          return;
                        }
                        if(password == null || password.isEmpty) {
                          setState(() {
                            _showErrDialog('密码不能为空');
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
          _showErrDialog(data['msg']);
        });
      }
    }
    catch(exception) {
      print('exception: ' + exception.toString());
    }

  }

  Future<void> _showErrDialog(String msg) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登录失败'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(msg)
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('关闭')),
            ],
          );
        }
    );
  }

}