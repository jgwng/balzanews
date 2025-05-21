import 'package:idb_shim/idb.dart';
import 'package:idb_shim/idb_browser.dart';

class LocalDB {
  static final LocalDB _instance = LocalDB._internal();

  factory LocalDB() => _instance;

  LocalDB._internal();

  static const _dbName = 'my_database';
  static const _bookmarkStore = 'bookmark';
  static const _historyStore = 'history';
  static const _dbVersion = 1;

  late Database _db;

  Future<void> init() async {
    if (_db != null) return; // already initialized

    final idbFactory = idbFactoryBrowser;

    _db = await idbFactory.open(_dbName, version: _dbVersion, onUpgradeNeeded: (e) {
      final db = e.database;
      if (!db.objectStoreNames.contains(_bookmarkStore)) {
        db.createObjectStore(_bookmarkStore, autoIncrement: true);
      }
    });
  }

  Future<void> put(String key, dynamic value) async {
    final txn = _db.transaction(_bookmarkStore, idbModeReadWrite);
    final store = txn.objectStore(_bookmarkStore);
    await store.put(value, key);
    await txn.completed;
  }

  Future<dynamic> get(String key) async {
    final txn = _db.transaction(_bookmarkStore, idbModeReadOnly);
    final store = txn.objectStore(_bookmarkStore);
    final value = await store.getObject(key);
    await txn.completed;
    return value;
  }

  Future<void> delete(String key) async {
    final txn = _db.transaction(_bookmarkStore, idbModeReadWrite);
    final store = txn.objectStore(_bookmarkStore);
    await store.delete(key);
    await txn.completed;
  }

  Future<List<String>> getAllKeys() async {
    final txn = _db.transaction(_bookmarkStore, idbModeReadOnly);
    final store = txn.objectStore(_bookmarkStore);
    final keys = await store.getAllKeys();
    await txn.completed;
    return keys.map((e) => e.toString()).toList();
  }
}
