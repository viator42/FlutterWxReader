import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:wx_reader/utils/styles.dart';
import 'book_store.dart';

class ShelfPage extends StatefulWidget {
  ShelfPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShelfPageState();
}

class _ShelfPageState extends State<ShelfPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('书架'),
      ),
      child: Padding(
          padding: EdgeInsets.fromLTRB(0, 48.0, 0, 0),
          child: Center(
            child: Container(
              width: 300.0,
              height: 160.0,
              child: Column(
                children: <Widget>[
                  Text('重拾阅读的习惯\n为生活埋下微小的信仰',
                    style: plainTextStyle,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => BookStorePage())
                        );
                      },
                      color: Colors.blue,
                      child: Text('去书城'),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}

