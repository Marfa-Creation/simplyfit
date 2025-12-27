import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProgramOverviewProvider extends ChangeNotifier {
  final Database _db;
  ProgramModel? _chosenProgram;
  List<ExerciseModel> _exercises = [];

  set chosenProgram(ProgramModel value) {
    _chosenProgram = value;
    notifyListeners();
  }

  ProgramModel? get chosenProgram => _chosenProgram;

  List<ExerciseModel> get exercises => _exercises;

  ProgramOverviewProvider(this._db, this._chosenProgram);

  void init() async {
    _exercises = (await _db.rawQuery(
      "SELECT * FROM exercises ORDER BY exercise_order ASC",
    )).map((map) => ExerciseModel.fromMap(map)).toList();

    notifyListeners();
  }

  void updateExercises(List<ExerciseModel> exercises) {
    _exercises = exercises;
    notifyListeners();
  }
}
