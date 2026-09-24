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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // ── Bids (Offers) Table
    await db.execute('''
      CREATE TABLE bids (
        id TEXT PRIMARY KEY,
        taskId TEXT NOT NULL,
        providerId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // ── Teams (Clubs) Table
    await db.execute('''
      CREATE TABLE teams (
        id TEXT PRIMARY KEY,
        ownerId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL
      )
    ''');

    // ── Tasks / Marketplace Items Table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        creatorId TEXT NOT NULL,
        data TEXT NOT NULL,
        listingType TEXT NOT NULL DEFAULT 'forSale',
        rentalDuration TEXT,
        createdAt INTEGER NOT NULL
      )
    ''');

    // ── Wars Table
    await db.execute('''
      CREATE TABLE wars (
        id TEXT PRIMARY KEY,
        challengerTeamId TEXT NOT NULL,
        defenderTeamId TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'pending',
        challengerScore INTEGER NOT NULL DEFAULT 0,
        defenderScore INTEGER NOT NULL DEFAULT 0,
        message TEXT,
        declaredAt INTEGER NOT NULL
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Add new columns to tasks table
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN listingType TEXT NOT NULL DEFAULT 'forSale'",
      );
      await db.execute('ALTER TABLE tasks ADD COLUMN rentalDuration TEXT');

      // Create wars table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS wars (
          id TEXT PRIMARY KEY,
          challengerTeamId TEXT NOT NULL,
          defenderTeamId TEXT NOT NULL,
          status TEXT NOT NULL DEFAULT 'pending',
          challengerScore INTEGER NOT NULL DEFAULT 0,
          defenderScore INTEGER NOT NULL DEFAULT 0,
          message TEXT,
          declaredAt INTEGER NOT NULL
        )
      ''');
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
