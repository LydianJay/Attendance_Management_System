import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBase {
  static Database? db;

  static Future<Database> initDatabase() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, 'system.db');
    db = await openDatabase(path);
    await _initTables();
    return db!;
  }

  static Future<void> _initTables() async {
    await _createTables();
  }

  static Future<void> _createTables() async {
    // debugPrint('Creating tables...');
    //await db!.execute('DROP TABLE IF EXISTS employee');
    await db!.execute('''

      CREATE TABLE IF NOT EXISTS employee (
        rID INTEGER PRIMARY KEY,
        fname TEXT,
        lname TEXT,
        mname TEXT
      );  
    
      ''');
    // await db!.execute('DROP TABLE IF EXISTS attendance');
    await db!.execute('''

      CREATE TABLE IF NOT EXISTS attendance (
        rID INTEGER,
        timeIn TEXT,
        date TEXT
      );  
    
      ''');
  }
}
