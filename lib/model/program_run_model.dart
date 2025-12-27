import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/provider/program_run_provider.dart';
import 'package:flutter/cupertino.dart';

@immutable
class ProgramRunModel {
  final List<ExerciseModel> exercises;
  final List<Step> steps;
  final int currentExerciseIdx;
  final int currentStepIdx;
  final int remainingSecs;
  final int extraSecs;
  final bool isRunning;
  final bool isFinished;

  const ProgramRunModel({
    required this.isFinished,
    required this.extraSecs,
    required this.remainingSecs,
    required this.exercises,
    required this.currentExerciseIdx,
    required this.steps,
    required this.isRunning,
    required this.currentStepIdx,
  });

  bool get isLastExercise => currentExerciseIdx >= exercises.length - 1;

  ExerciseModel get currentExercise => exercises[currentExerciseIdx];
  Step get currentStep => steps[currentStepIdx];
  set currentStep(Step value) => steps[currentStepIdx] = value;

  ProgramRunModel copyWith({
    List<ExerciseModel>? exercises,
    List<Step>? steps,
    int? currentExerciseIdx,
    bool? isRunning,
    int? currentStepIdx,
    int? remainingSecs,
    int? extraSecs,
    bool? isFinished,
  }) {
    return ProgramRunModel(
      isFinished: isFinished ?? this.isFinished,
      extraSecs: extraSecs ?? this.extraSecs,
      exercises: exercises ?? this.exercises,
      currentExerciseIdx: currentExerciseIdx ?? this.currentExerciseIdx,
      steps: steps ?? this.steps,
      isRunning: isRunning ?? this.isRunning,
      currentStepIdx: currentStepIdx ?? this.currentStepIdx,
      remainingSecs: remainingSecs ?? this.remainingSecs,
    );
  }
}
