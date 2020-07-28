import 'data_provider.dart';

class CacheManager {
  static final CacheManager _singleton = CacheManager._internal();
  DataProvider _dataProvider;

  factory CacheManager() {
    return _singleton;
  }

  CacheManager._internal() {
    _dataProvider = DataProvider();
  }

  get(String key) {
    return _dataProvider.get(key);
  }

  put(String key, String value) {
    _dataProvider.put(key, value, 0);
  }

}