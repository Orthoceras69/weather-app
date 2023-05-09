import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note.dart';

class CityDatabase {
  static final CityDatabase instance = CityDatabase._init();

  static Database? _database;

  CityDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${CityFields.id} $idType, 
  ${CityFields.name} $textType,
  ${CityFields.latitude} $textType,
  ${CityFields.longitude} $textType,

  )
''');
  }

  Future<City> create(City city) async {
    // final json = note.toJson();
    // final columns =
    //     '${CityFields.longitude}, ${CityFields.description}, ${CityFields.time}';
    // final values =
    //     '${json[CityFields.longitude]}, ${json[CityFields.description]}, ${json[CityFields.time]}';
    // final id = await db
    //     .rawInsert('INSERT INTO table_name ($columns) VALUES ($values)');
    final db = await instance.database;
    final id = await db.insert(tableNotes, city.toJson());
    return city.copy(id: id);
  }

  Future<City> readNote(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableNotes,
      columns: CityFields.values,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return City.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<City>> readAllNotes() async {
    final db = await instance.database;

    final orderBy = '${CityFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableNotes ORDER BY $orderBy');

    final result = await db.query(tableNotes, orderBy: orderBy);

    return result.map((json) => City.fromJson(json)).toList();
  }

  Future<int> update(City note) async {
    final db = await instance.database;

    return db.update(
      tableNotes,
      note.toJson(),
      where: '${CityFields.id} = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableNotes,
      where: '${CityFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }

  void inserting() async {
    var london =
        const City(name: 'london', latitude: '45.4545', longitude: '52.5252');
    await create(london);
  }
}
