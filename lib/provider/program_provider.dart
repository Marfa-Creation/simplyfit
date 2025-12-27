import 'dart:async';

import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/db_provider.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final programProvider = AsyncNotifierProvider.autoDispose(ProgramNotifier.new);

class ProgramNotifier extends AsyncNotifier<List<ProgramModel>> {
  @override
  FutureOr<List<ProgramModel>> build() async {
    final db = (await ref.read(dbProvider.future));
    return (await db.rawQuery(
      "SELECT * FROM programs ORDER BY name",
    )).map((map) => ProgramModel.fromMap(map)).toList();
  }

  void createProgram(ProgramModel program) async {
    final db = (await ref.read(dbProvider.future));
    final rowid = await db.insert("programs", program.toMap());
    final id =
        (await db.query(
              "programs",
              where: "rowid = ?",
              whereArgs: [rowid],
            ))[0]["id"]
            as int;

    if (!state.hasValue) return;

    final programs = List.of(state.requireValue);

    programs.add(ProgramModel(id: id, name: program.name));

    programs.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    state = AsyncValue.data(programs);
  }

  void deleteProgram(int id) async {
    final db = (await ref.read(dbProvider.future));
    await db.delete("programs", where: "id = ?", whereArgs: [id]);

    if (!state.hasValue) return;

    final programs = List.of(state.requireValue);

    programs.removeWhere((element) => element.id == id);

    final programId = id;
    ref
        .read(exerciseProvider(ref.read(selectedProgramProvider)!.id!).notifier)
        .deleteAllExercise(programId);

    state = AsyncValue.data(programs);
  }

  void renameProgram(int id, String newName) async {
    final db = (await ref.read(dbProvider.future));
    await db.update(
      "programs",
      ProgramModel(id: id, name: newName).toMap(),
      where: "id = ?",
      whereArgs: [id],
    );

    if (!state.hasValue) return;

    final programs = List.of(state.requireValue);

    for (int i = 0; i < programs.length; i++) {
      if (programs[i].id == id) {
        programs[i] = ProgramModel(id: id, name: newName);
      }
    }

    ref
        .read(selectedProgramProvider.notifier)
        .selectProgram(ProgramModel(id: id, name: newName));

    state = AsyncValue.data(programs);
  }
}
