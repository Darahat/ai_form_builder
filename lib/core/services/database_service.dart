
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        uid TEXT PRIMARY KEY,
        name TEXT,
        email TEXT NOT NULL,
        role TEXT,
        photoURL TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        tid TEXT PRIMARY KEY,
        title TEXT,
        isCompleted INTEGER NOT NULL,
        taskCreationTime TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE setting_definitions(
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        defaultValue TEXT NOT NULL,
        dataType TEXT NOT NULL,
        isUserSpecific INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_chats(
        id TEXT PRIMARY KEY,
        chatTextBody TEXT,
        sentTime TEXT NOT NULL,
        isSeen INTEGER,
        isReplied INTEGER,
        replyText TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE utou_chats(
        id TEXT PRIMARY KEY,
        chatTextBody TEXT,
        sentTime TEXT NOT NULL,
        isDelivered INTEGER,
        isRead INTEGER,
        senderId TEXT,
        receiverId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_form_builder_chats(
        id TEXT PRIMARY KEY,
        message TEXT NOT NULL,
        isUser INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE form_fields(
        id TEXT PRIMARY KEY,
        question TEXT NOT NULL,
        type TEXT NOT NULL,
        options TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_generated_forms(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_generated_form_fields(
        form_id TEXT NOT NULL,
        field_id TEXT NOT NULL,
        FOREIGN KEY (form_id) REFERENCES ai_generated_forms (id) ON DELETE CASCADE,
        FOREIGN KEY (field_id) REFERENCES form_fields (id) ON DELETE CASCADE
      )
    ''');
  }
}
