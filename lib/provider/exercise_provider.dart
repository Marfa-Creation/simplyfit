import 'dart:async';

import 'package:custom_exercise/model/exercise_import_model.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/provider/db_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exerciseProvider = AsyncNotifierProvider.family(ExerciseNotifier.new);

class ExerciseNotifier extends AsyncNotifier<List<ExerciseModel>> {
  final int _programId;

  ExerciseNotifier(this._programId);

  @override
  FutureOr<List<ExerciseModel>> build() async {
    final db = await ref.read(dbProvider.future);

    return (await db.rawQuery(
      "SELECT * FROM exercises WHERE program_id = ? ORDER BY exercise_order ASC",
      [_programId],
    )).map((map) => ExerciseModel.fromMap(map)).toList();
  }

  void onReorder(int programId, int oldIndex, int newIndex) async {
    final db = await ref.read(dbProvider.future);

    if (newIndex > oldIndex) /* move item down */ {
      newIndex -= 1;

      db.transaction((txn) async {
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
      db.transaction((txn) async {
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

    _uniqueCheck(programId);

    if (!state.hasValue) return;

    var exercises = List.of(state.requireValue);

    final reorderedProgram = exercises.removeAt(oldIndex);
    exercises.insert(newIndex, reorderedProgram);

    state = AsyncValue.data(exercises);
  }

  void _uniqueCheck(int programId) async {
    final db = await ref.read(dbProvider.future);

    final result = await db.rawQuery(
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
  }

  void addExercise(ExerciseModel exercise) async {
    final db = await ref.read(dbProvider.future);

    final rowid = await db.insert("exercises", exercise.toMap());
    final id =
        (await db.query(
              "exercises",
              where: "rowid = ?",
              whereArgs: [rowid],
            ))[0]["id"]
            as int;

    if (!state.hasValue) return;

    var exercises = List.of(state.requireValue);

    exercises.add(exercise.copyWith(id: id));

    state = AsyncValue.data(exercises);
  }

  void importExercises(List<ExerciseImportModel> exercises) async {
    final db = await ref.read(dbProvider.future);

    await db.transaction((txn) async {

      for (final exercise in exercises) {
        final exerciseModel = ExerciseModel(
          id: null,
          programId: _programId,
          preparation: exercise.preparation,
          exerciseOrder: exercise.exerciseOrder,
          name: exercise.name,
          duration: exercise.duration,
          repetition: exercise.repetition,
        );
        final rowid = await txn.insert("exercises", exerciseModel.toMap());
        final id =
            (await txn.query(
                  "exercises",
                  where: "rowid = ?",
                  whereArgs: [rowid],
                ))[0]["id"]
                as int;

        if (!state.hasValue) return;

        var exercises = List.of(state.requireValue);

        exercises.add(exerciseModel.copyWith(id: id));

        state = AsyncValue.data(exercises);
      }
    });
  }

  void editExercise(int id, ExerciseModel exercise) async {
    final db = await ref.read(dbProvider.future);

    await db.update(
      "exercises",
      exercise.toMap()..remove("exercise_order"),
      where: "id = ?",
      whereArgs: [id],
    );

    if (!state.hasValue) return;

    var exercises = List.of(state.requireValue);

    for (int i = 0; i < exercises.length; i++) {
      if (exercises[i].id == id) {
        exercises[i] = exercise;
      }
    }

    state = AsyncValue.data(exercises);
  }

  void deleteAllExercise(int programId) async {
    final db = await ref.read(dbProvider.future);

    await db.delete(
      "exercises",
      where: "program_id = ?",
      whereArgs: [programId],
    );

    state = AsyncValue.data([]);
  }

  void deleteExercise(int id) async {
    final db = await ref.read(dbProvider.future);

    await db.delete("exercises", where: "id = ?", whereArgs: [id]);

    if (!state.hasValue) return;

    var exercises = List.of(state.requireValue);

    exercises.removeWhere((element) => element.id == id);

    state = AsyncValue.data(exercises);
  }
}
