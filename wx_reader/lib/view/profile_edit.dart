import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/globle.dart';
import 'package:wx_reader/utils/static_values.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileEditPageState();
  }
}

class _ProfileEditPageState extends State<ProfileEditPage> {
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
        middle: Text('编辑个人资料'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Text('头像'),
            trailing: ClipOval(
              child: SizedBox(
                width: 48.0,
                height: 48.0,
                child: Image.network(serverPath + user.headimg,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
            height: 1.5,
            color: Colors.black87,
          ),

          ListTile(
            leading: Text('昵称'),
            trailing: Text(user.nickname),
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
            height: 1.5,
            color: Colors.black87,
          ),

          ListTile(
            leading: Text('介绍自己'),
            trailing: Text(user.desp),
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
            height: 1.5,
            color: Colors.black87,
          ),

          ListTile(
            leading: Text('我的签名'),
            trailing: Text(user.signing),
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
            height: 1.5,
            color: Colors.black87,
          ),

        ],
      ),
    );
  }

}
