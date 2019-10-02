import 'package:wx_reader/utils/http.dart';

var http = new HttpUtils();

class Api {
  // 用户注册
  static Future register({String tel, String password}) async {
    return await http.post('/app/user/login/', {'tel': tel, 'password': password});
  }

}

