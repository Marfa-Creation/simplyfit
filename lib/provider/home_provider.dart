import 'package:custom_exercise/model/program_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class HomeProvider extends ChangeNotifier {
  final Database _db;
  List<ProgramModel> _programs = [];

  List<ProgramModel> get programs => _programs;

  HomeProvider(this._db);

  void init() async {
    _programs = (await _db.rawQuery(
      "SELECT * FROM programs ORDER BY name",
    )).map((map) => ProgramModel.fromMap(map)).toList();

    notifyListeners();
  }

  void createProgram(ProgramModel program) async {
    final rowid = await _db.insert("programs", program.toMap());
    final id =
        (await _db.query(
              "programs",
              where: "rowid = ?",
              whereArgs: [rowid],
            ))[0]["id"]
            as int;
    _programs.add(ProgramModel(id: id, name: program.name));

    _programs.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    notifyListeners();
  }

  void deleteProgram(int id) async {
    await _db.delete("programs", where: "id = ?", whereArgs: [id]);

    _programs.removeWhere((element) => element.id == id);

    notifyListeners();
  }

  void renameProgram(int id, String newName) async {
    await _db.update(
      "programs",
      ProgramModel(id: id, name: newName).toMap(),
      where: "id = ?",
      whereArgs: [id],
    );

    for (int i = 0; i < _programs.length; i++) {
      if (_programs[i].id == id) {
        _programs[i] = ProgramModel(id: id, name: newName);
      }
    }

    notifyListeners();
  }
}
