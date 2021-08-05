import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:qr_reader/models/scan_model.dart';
export 'package:qr_reader/models/scan_model.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await initDB();

    return _database;
  }

  Future<Database> initDB() async {
    // TODO: Path de donde almacenaremos la DB
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScanDB.db');
    print(path);

    //Crear base de datos

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('''
      CREATE TABLE Scans(
        id INTEGER PRIMARY KEY,
        tipo TEXT,
        valor TEXT
      )
      ''');
    });
  }

  Future<int> nuevoScanRow(ScanModel nuevoScan) async {
    final id = nuevoScan.id;
    final tipo = nuevoScan.tipo;
    final valor = nuevoScan.valor;

    // TODO:Verificar la base de datos
    final db = await database;

    final res = await db!.rawInsert('''
    INSERT INTO Scans(id, tipo, valor)
    VALUES($id, '$tipo', '$valor')
    ''');

    return res;
  }

  Future<int> nuevoScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db!.insert("Scans", nuevoScan.toJson());
    // print(res);
    return res;
  }

  Future<ScanModel?> getScanById(int id) async {
    final db = await database;

    final res = await db!.query('Scans', where: 'id = ?', whereArgs: [id]);

    return res.isNotEmpty ? ScanModel.fromJson(res.first) : null;
  }

  Future<List<ScanModel>> getTodosScans() async {
    final db = await database;
    //Puede retornar todos y no solo uno. Eliminemos when
    final res = await db?.query('Scans');

    List<ScanModel> list = res!.isNotEmpty
        ? res.map((scan) => new ScanModel.fromJson(scan)).toList()
        : [];

    return list;
    //Daba error de match asi que se cambio
    //return res!.isNotEmpty ? res.map((s) => new ScanModel.fromJson(s)).toList() : null;
  }

  Future<List<ScanModel>> getScanByTipo(String tipo) async {
    final db = await database;

    final res = await db!.rawQuery('''
    SELECT * FROM Scans WHERE tipo = '$tipo'
    ''');

    List<ScanModel> list = res.isNotEmpty
        ? res.map((scan) => new ScanModel.fromJson(scan)).toList()
        : [];

    return list;
  }

  Future<int> updateScan(ScanModel nuevoScan) async {
    final db = await database;

    final res = await db!.update('Scans', nuevoScan.toJson(),
        where: 'id = ?', whereArgs: [nuevoScan.id]);

    return res;
  }

  Future<int> deleteScan(int id) async {
    final db = await database;

    final res = await db!.delete('Scans', where: 'id = ?', whereArgs: [id]);

    return res;
  }

  Future<int> deleteAllScans() async {
    final db = await database;

    final res = await db!.rawDelete(''' 
    DELETE FROM Scans
    ''');

    return res;
  }
}
