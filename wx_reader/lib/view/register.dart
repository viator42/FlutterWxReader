import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _telController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isShowingErrDialog = false;
  String errMsg = '';

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
        middle: Text('注册'),
      ),
      body: Align(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '手机号',
                ),
                controller: _telController,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '密码',
                ),
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

                    _doRegister(tel, password);
                  },
                  color: Colors.blue,
                  child: Text('注册'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _doRegister(tel, password) async {
//    Response data = await Api.register();
//    if(data != null) {
//      if(data.data['success']) {
//
//      }
//      else {
//
//      }
//    }
//    else {
//
//    }


    // 轮播图数据
//    var bannerData = data.data['banner'];
//    List<Widget> bannerList = List();
//    bannerData.forEach((item) => bannerList.add(CachedNetworkImage(
//      imageUrl: item['image_url'],
//      errorWidget: (context, url, error) => new Icon(Icons.error),
//      fit: BoxFit.fill,
//    )));
//    // channel数据
//    var channelData = data.data['channel'];
//    // 制造商数据
//    var brandData = data.data['brandList'];
//    // 新品推荐
//    var newsData = data.data['newGoodsList'];
//    // 人气推荐
//    var hotData = data.data['hotGoodsList'];
//    // 专题精选
//    var topicList = data.data['topicList'];
//    // 推荐商品
//    var categoryList = data.data['categoryList'];
//    setState(() {
//      banner = bannerList;
//      channel = channelData;
//      brand = brandData;
//      news = newsData;
//      hot = hotData;
//      topic = topicList;
//      category = categoryList;
//      isLoading = false;
//    });
  }

}
