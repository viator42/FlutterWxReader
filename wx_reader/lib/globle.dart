import 'package:quiver/cache.dart';
import 'package:wx_reader/model/user.dart';

/**
 * 全局变量
*/
User user;
MapCache<String, String> mapCache = MapCache.lru(maximumSize: 512);