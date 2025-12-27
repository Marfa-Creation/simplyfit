import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/home_provider.dart';
import 'package:custom_exercise/provider/program_overview_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class EditProgramProvider extends ChangeNotifier {
  final Database _db;
  final int _programId;
  // final ProgramOverviewProvider? _programOverviewProvider;
  // final HomeProvider _homeProvider;
  List<ExerciseModel> _exercises = [];

  List<ExerciseModel> get exercises => _exercises;

  EditProgramProvider(
    this._db,
    this._programId,
    // this._programOverviewProvider, this._homeProvider
  );

  void init() async {
    _exercises = (await _db.rawQuery(
      "SELECT * FROM exercises ORDER BY exercise_order ASC WHERE program_id = ?",
      [_programId],
    )).map((map) => ExerciseModel.fromMap(map)).toList();

    notifyListeners();
  }

  // void renameProgram(int id, String newName) async {
  //   await _db.update(
  //     "programs",
  //     ProgramModel(id: id, name: newName).toMap(),
  //     where: "id = ?",
  //     whereArgs: [id],
  //   );

  //   notifyListeners();

  //   // _programOverviewProvider.re()
  //   // _homeProvider.renameProgram(id, newName);
  // }
  //
  // void debug() {
  //   for (int i = 0; i < exercises.length; i++) {
  //     print(
  //       "${exercises[i].toMap()
  //         ..remove("id")
  //         ..remove("program_id")
  //         ..remove("preparation")
  //         ..remove("repetition")
  //         ..remove("duration")}",
  //     );
  //   }
  //   print(
  //     "=========================================================================================",
  //   );
  // }

  void onReorder(int programId, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) /* move item down */ {
      newIndex -= 1;

      _db.transaction((txn) async {
        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = -1 WHERE exercise_order = ? AND program_id = ?",
          [oldIndex, programId],
        );

        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = exercise_order - 1 WHERE exercise_order > ? AND exercise_order <= ? AND program_id = ?",
          [oldIndex, newIndex, programId],
        );

        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = ? WHERE exercise_order = -1 AND program_id = ?",
          [newIndex, programId],
        );
      });
    } else if (newIndex < oldIndex) /* move item up */ {
      _db.transaction((txn) async {
        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = -1 WHERE exercise_order = ? AND program_id = ?",
          [oldIndex, programId],
        );

        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = exercise_order + 1 WHERE exercise_order < ? AND exercise_order >= ? AND program_id = ?",
          [oldIndex, newIndex, programId],
        );

        await txn.rawUpdate(
          "UPDATE exercises SET exercise_order = ? WHERE exercise_order = -1 AND program_id = ?",
          [newIndex, programId],
        );
      });
    }
    print("onreorder $oldIndex -> $newIndex");

    _uniqueCheck(programId);

    final reorderedProgram = _exercises.removeAt(oldIndex);
    _exercises.insert(newIndex, reorderedProgram);

    notifyListeners();
    // );
  }

  void _uniqueCheck(int programId) async {
    final result = await _db.rawQuery(
      '''
      SELECT EXISTS(
        SELECT 1
        FROM exercises
        WHERE program_id = ?
        GROUP BY exercise_order
        HAVING COUNT(*) > 1
      ) AS has_duplicates
  ''',
      [programId],
    );

    final hasDuplicates = result.first['has_duplicates'] == 1;

    assert(hasDuplicates == false);
    // await _db.
  }

  // void swapOrder(int programId, int oldIdx, int newIdx) {
  //   // if (newIdx > oldIdx) {
  //   //   newIdx -= 1;
  //   // }
  //   // final item = _exercises.removeAt(oldIdx);
  //   // _exercises.insert(newIdx, item);
  //   /////////////////////////////////

  //   // if (oldIdx < newIdx) {
  //   // removing the item at oldIndex will shorten the list by 1.
  //   // newIdx -= 1;
  //   // }
  //   // final  element = _exercises.removeAt(oldIdx);
  //   // _exercises.insert(newIdx, element);
  //   // notifyListeners();
  //   // print("$oldIdx -> $_newIdx");
  //   // debug();

  //   // final reorder = _exercises.removeAt(oldIdx);
  //   // _exercises.insert(_newIdx, reorder);
  //   // notifyListeners();

  //   // int newIdx = _newIdx - 1;

  //   _db.transaction((trans) async {
  //     final tmp = newIdx;
  //     await trans.rawUpdate(
  //       "UPDATE exercises SET exercise_order = -1 WHERE exercise_order = ? AND program_id = ?",
  //       [newIdx, programId],
  //     );
  //     debug();

  //     await trans.rawUpdate(
  //       "UPDATE exercises SET exercise_order = ? WHERE exercise_order = ? AND program_id = ?",
  //       [newIdx, oldIdx, programId],
  //     );
  //     debug();

  //     await trans.rawUpdate(
  //       "UPDATE exercises SET exercise_order = exercise_order - 1 WHERE exercise_order > ? AND exercise_order < ? AND program_id = ?",
  //       [oldIdx, newIdx, programId],
  //     );

  //     await trans.rawUpdate(
  //       "UPDATE exercises SET exercise_order = ? WHERE exercise_order = -1 AND program_id = ?",
  //       [tmp - 1, programId],
  //     );
  //     debug();
  //   });

  //   init();
  // }

  void addExercise(ExerciseModel exercise) async {
    final rowid = await _db.insert("exercises", exercise.toMap());
    final id =
        (await _db.query(
              "exercises",
              where: "rowid = ?",
              whereArgs: [rowid],
            ))[0]["id"]
            as int;

    _exercises.add(exercise.copyWith(id: id));

    notifyListeners();
    // _programOverviewProvider?.updateExercises(_exercises);
  }

  void editExercise(int id, ExerciseModel exercise) async {
    await _db.update(
      "exercises",
      exercise.toMap()..remove("exercise_order"),
      where: "id = ?",
      whereArgs: [id],
    );

    for (int i = 0; i < _exercises.length; i++) {
      if (_exercises[i].id == id) {
        _exercises[i] = exercise;
      }
    }

    notifyListeners();
  }

  void deleteExercise(int id) async {
    await _db.delete("exercises", where: "id = ?", whereArgs: [id]);

    _exercises.removeWhere((element) => element.id == id);

    notifyListeners();
  }
}
