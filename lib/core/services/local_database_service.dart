import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class LocalDatabaseService {
  static final LocalDatabaseService instance = LocalDatabaseService._init();
  static Database? _database;

  LocalDatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nexus_placeholder.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // We store Freezed objects as JSON strings in a 'data' column
    // to make schema migrations trivial for this placeholder.

    // ── Bids (Offers) Table ─────────────────────────────
    await db.execute('''
      CREATE TABLE bids (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        providerId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // ── Teams (Clubs) Table ──────────────────────────────
    await db.execute('''
      CREATE TABLE teams (
        id TEXT PRIMARY KEY,
        ownerId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // ── Tasks Table (Offline override placeholder) ──────
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        creatorId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
