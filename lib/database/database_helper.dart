import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';
import '../models/wish.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("tet_manager.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contacts(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        groupName TEXT,
        note TEXT,
        greeted INTEGER,
        sentWish TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE wishes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT
      )
    ''');
  }

  // ─── CONTACTS ───────────────────────────────

  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;
    final maps = await db.query('contacts');
    return maps.map((m) => Contact.fromMap(m)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int id) async {
    final db = await database;
    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  // ─── WISHES ─────────────────────────────────

  Future<int> insertWish(Wish wish) async {
    final db = await database;
    return db.insert('wishes', wish.toMap());
  }

  Future<List<Wish>> getWishes() async {
    final db = await database;
    final maps = await db.query('wishes');
    return maps.map((m) => Wish.fromMap(m)).toList();
  }

  Future<int> deleteWish(int id) async {
    final db = await database;
    return db.delete('wishes', where: 'id = ?', whereArgs: [id]);
  }
}