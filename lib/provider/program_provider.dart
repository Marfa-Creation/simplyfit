import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:custom_exercise/model/exercise_import_model.dart';
import 'package:custom_exercise/model/program_import_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/db_provider.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';

final programProvider = AsyncNotifierProvider.autoDispose(ProgramNotifier.new);

class ProgramNotifier extends AsyncNotifier<List<ProgramModel>> {
  @override
  FutureOr<List<ProgramModel>> build() async {
    final db = (await ref.read(dbProvider.future));
    return (await db.rawQuery(
      "SELECT * FROM programs ORDER BY name",
    )).map((map) => ProgramModel.fromMap(map)).toList();
  }

  Future<int?> createProgram(ProgramModel program) async {
    final db = (await ref.read(dbProvider.future));
    final rowid = await db.insert("programs", program.toMap());
    final id =
        (await db.query(
              "programs",
              where: "rowid = ?",
              whereArgs: [rowid],
            ))[0]["id"]
            as int;

    if (!state.hasValue) return null;

    final programs = List.of(state.requireValue);

    programs.add(ProgramModel(id: id, name: program.name));

    programs.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    state = AsyncValue.data(programs);

    return id;
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


  Future<void> exportSelectedProgram() async {
    final selectedProgramId = ref.read(selectedProgramProvider)!.id!;
    final program = (await future)
        .where((element) => element.id == selectedProgramId)
        .toList()[0];

    final exercises = (await ref.read(exerciseProvider(program.id!).future))
        .map((e) {
          return {
            "preparation": e.preparation,
            "exercise_order": e.exerciseOrder,
            "repetition": e.repetition,
            "duration": e.duration,
            "name": e.name,
          };
        })
        .toList();
    final exported = {"name": program.name, "exercises": exercises};

    final picker = await FilePicker.platform.getDirectoryPath();

    if (picker == null) return;

    if (picker == '/') return;

    var suffix = "";

    for (int i = 0; true; i++) {
      final path = join(picker, "${program.name}$suffix.json");
      final file = File(path);
      try {
        await file.create(recursive: false, exclusive: true);

        final jsonString = jsonEncode(exported);

        file.writeAsString(jsonString);

        break;
      } on PathExistsException {
        suffix = "-$i";
        continue;
      }
    }
  }
}
