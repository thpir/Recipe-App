// ignore_for_file: constant_identifier_names

import 'package:recipe_app/models/recipe.dart';
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseModel {
  static const String DB_NAME = "recipeDatabase.db";
  static const int DB_VERSION = 1;
  static const String CREATE_TABLE_RECIPES = """
    CREATE TABLE IF NOT EXISTS recipes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      ingredients TEXT,
      preparation_time INTEGER,
      cooking_time INTEGER,
      portion_size TEXT,
      difficulty TEXT,
      categories TEXT,
      instructions TEXT,
      photo TEXT,
      favorite INTEGER,
      source TEXT
    )
    """;
  static const String CREATE_TABLE_UNITS = """
    CREATE TABLE IF NOT EXISTS units(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    """;
  static const String CREATE_TABLE_CATEGORIES = """
    CREATE TABLE IF NOT EXISTS categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT
    )
    """;

  static Future<sql.Database> initializeDatabase() async {
    String databasePath = await sql.getDatabasesPath();
    String path = '$databasePath/$DB_NAME';
    return await sql.openDatabase(path, version: DB_VERSION,
        onCreate: (sql.Database db, int version) async {
      await db.execute(CREATE_TABLE_RECIPES);
      await db.execute(CREATE_TABLE_UNITS);
      await db.execute(CREATE_TABLE_CATEGORIES);
    });
  }

  static Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
    final db = await DatabaseModel.initializeDatabase();
    return db.query(tableName);
  }

  static Future<void> insertItem(String table, Map<String, Object?> data) async {
    final db = await DatabaseModel.initializeDatabase();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<void> deleteItem(String table, int id) async {
    final db = await DatabaseModel.initializeDatabase();
    db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> update(Recipe recipe,) async {
    final db = await DatabaseModel.initializeDatabase();
    db.update(
        "recipes",
        {
          'name': recipe.name,
          'ingredients': recipe.ingredients,
          'preparation_time': recipe.preparationTime,
          'cooking_time': recipe.cookingTime,
          'portion_size': recipe.portionSize,
          'difficulty': recipe.difficulty,
          'categories': recipe.categories,
          'instructions': recipe.instructions,
          'photo': recipe.photo,
          'favorite': recipe.favorite,
          'source': recipe.source
        },
        where: 'id = ?',
        whereArgs: [recipe.id!]);
  }

  static Future<void> likeRecipe(int id, int favorite,) async {
    final db = await DatabaseModel.initializeDatabase();
    db.update(
        "recipes",
        {
          'favorite': favorite
        },
        where: 'id = ?',
        whereArgs: [id]);
  }
}
