import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'db_model/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;

  TodoDatabase._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB('todoList.db');
      return _database!;
    }
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
CREATE TABLE $tableTodo ( 
  ${TodoFields.id} $idType,
  ${TodoFields.title} $textType,
  ${TodoFields.desc} $textType,
  ${TodoFields.status} $integerType DEFAULT 0,
  ${TodoFields.image} $textType
  )
''');
  }

  Future<TodoList> create(TodoList todo) async {
    final db = await instance.database;
    final id = await db.insert(tableTodo, todo.toJson());
    return todo.copy(id: id);
  }

  Future<TodoList> read(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTodo,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TodoList.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<TodoList>> readAll() async {
    final db = await instance.database;
    final result = await db.query(tableTodo);
    return result.map((json) => TodoList.fromJson(json)).toList();
  }

  Future<int> update(TodoList todo) async {
    final db = await instance.database;
    return db.update(
      tableTodo,
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTodo,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
