import 'dart:convert';
import 'dart:io';

import 'package:custom_exercise/model/exercise_import_model.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_import_model.dart';
import 'package:file_picker/file_picker.dart';

enum ExerciseMetric { repetition, duration }

class Import {
  static Future<ProgramImportModel?> importProgram() async {
    final picker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["json"],
      allowMultiple: false,
    );

    if (picker == null) return null;

    // try {
      final file = File(picker.files[0].path!);

      final content = await file.readAsString();

      final Map<String, dynamic> importedProgram = jsonDecode(content);
      if (importedProgram["name"] == null) {
        throw FormatException('Missing required field "name"');
      }
      if (importedProgram["exercises"] == null) {
        throw FormatException('Missing required field "exercises"');
      }

      final List<ExerciseImportModel> importedExercises =
          (importedProgram["exercises"] as List<dynamic>).map((e) {
            final preparation = e["preparation"];
            final exerciseOrder = e["exercise_order"];
            final name = e["name"];
            final duration = e["duration"];
            final repetition = e["repetition"];

            if (preparation == null) {
              throw FormatException('Missing required field "preparation"');
            }
            if (exerciseOrder == null) {
              throw FormatException('Missing required field "exercise_order"');
            }
            if (name == null) {
              throw FormatException('Missing required field "name"');
            }

            if (!((duration == null && repetition != null) ||
                (repetition == null && duration != null))) {
              throw FormatException('Missing required field "name"');
            }

            return ExerciseImportModel(
              preparation: preparation as int,
              exerciseOrder: exerciseOrder as int,
              name: name as String,
              duration: duration as int?,
              repetition: repetition as int?,
            );
          }).toList();

      return ProgramImportModel(
        name: importedProgram["name"],
        exercises: importedExercises,
      );
    }
    // on FormatException catch (e, trace) {
    //   state = AsyncValue.error(e, trace);
    //   return null;
    // }
  // }
}

sealed class FormMode {
  const FormMode();

  factory FormMode.add() => FormModeAdd();
  factory FormMode.edit(ExerciseModel selectedExercise) =>
      FormModeEdit(selectedExercise);
}

class FormModeAdd extends FormMode {
  const FormModeAdd();
}

class FormModeEdit extends FormMode {
  final ExerciseModel selectedExercise;
  const FormModeEdit(this.selectedExercise);
}

String formatSecs(int secsValue) {
  final mins = (secsValue / 60).toInt().toString().padLeft(2, '0');
  final secs = (secsValue % 60).toString().padLeft(2, '0');

  return "$mins:$secs";
}
