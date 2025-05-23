import 'package:balzanewsweb/core/consts.dart';
import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._internal();

  factory LocalDB() => _instance;

  LocalDB._internal();

  static const _dbName = 'ARTICLE_DATABASE';
  static const _dbVersion = 1;

  late Database _db;

  Future<void> init() async {
    final idbFactory = idbFactoryBrowser;

    _db = await idbFactory.open(_dbName, version: _dbVersion, onUpgradeNeeded: (e) {
      final db = e.database;
      if (!db.objectStoreNames.contains(AppKeys.ARTICLE_BOOKMARK_STORE)) {
        db.createObjectStore(AppKeys.ARTICLE_BOOKMARK_STORE, autoIncrement: true);
      }
      if (!db.objectStoreNames.contains(AppKeys.ARTICLE_HISTORY_STORE)) {
        db.createObjectStore(AppKeys.ARTICLE_HISTORY_STORE, autoIncrement: true);
      }
    });
  }

  Future<void> put(String storeDB, String key, dynamic value) async {
    final txn = _db.transaction(storeDB, idbModeReadWrite);
    final store = txn.objectStore(storeDB);
    await store.put(value, key);
    await txn.completed;
  }

  Future<dynamic> get(String storeDB, String key) async {
    final txn = _db.transaction(storeDB, idbModeReadOnly);
    final store = txn.objectStore(storeDB);
    final value = await store.getObject(key);
    await txn.completed;
    return value;
  }

  Future<void> delete(String storeDB, String key) async {
    final txn = _db.transaction(storeDB, idbModeReadWrite);
    final store = txn.objectStore(storeDB);
    await store.delete(key);
    await txn.completed;
  }

  Future<List<String>> getAllKeys(String storeDB) async {
    final txn = _db.transaction(storeDB, idbModeReadOnly);
    final store = txn.objectStore(storeDB);
    final keys = await store.getAllKeys();
    await txn.completed;
    return keys.map((e) => e.toString()).toList();
  }
}
