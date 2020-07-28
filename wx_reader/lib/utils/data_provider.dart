import 'package:sqflite/sqflite.dart';

class DataProvider {
  var _db = null;

  DataProvider() {
    _init();
  }

  /**
   * 初始化数据库
   */
  _init() async {
    _db = await openDatabase('cache.db',
      onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE Cache (id INTEGER PRIMARY KEY, key TEXT, value TEXT, timestamp INTEGER)');
      },
      onOpen: null,
    );
  }

  /**
   * 添加缓存表
   */
  put(String key, String value, int timestamp) async {
    //查询是否存在
    var exists = await _db.query('Cache',
      columns: ['id'],
      where: "key = ?",
      whereArgs: key,
    );

    if(exists != null && exists.length > 0) {
      //更新缓存
      _db.update('Cache',
        {
          'value': value,
          'timestamp': timestamp,
        },
        where: "key = ?",
        whereArgs: key,
      );
    }
    else {
      //添加缓存
      _db.insert('my_table', {'key': key, 'value': value, 'timestamp': timestamp});
    }

  }

  /**
   * 读取缓存
   */
  get(String key) async {
    List<Map> data = await _db.query('Cache',
      columns: ['id'],
      where: "key = ?",
      whereArgs: key,
    );

    if(data != null && data.length > 0) {
      Map map = data[0];
      return map['value'];
    }
    else {
      return null;
    }

  }

  /**
   * 关闭数据库
   */
  close() {
    if(_db != null) {
      _db.close();
    }
  }


}