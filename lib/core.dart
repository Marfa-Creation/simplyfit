import 'package:custom_exercise/model/exercise_model.dart';

enum ExerciseMetric { repetition, duration }

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
