import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_run_model.dart';
import 'package:custom_exercise/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final programRunProvider = AsyncNotifierProvider.autoDispose.family(
  ProgramRunNotifier.new,
);

enum StepType { preparation, duration, repetition }

@immutable
class Step {
  final StepType stepType;
  final int value;

  const Step({required this.stepType, required this.value});

  Step copyWith({StepType? stepType, int? value}) {
    return Step(
      stepType: stepType ?? this.stepType,
      value: value ?? this.value,
    );
  }
}

class ProgramRunNotifier extends AsyncNotifier<ProgramRunModel> {
  final int _programId;
  Timer? _timer;
  final Stopwatch _stopwatch = Stopwatch();

  ProgramRunNotifier(this._programId);

  @override
  FutureOr<ProgramRunModel> build() async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final db = await ref.read(dbProvider.future);

    final exercises = (await db.rawQuery(
      "SELECT * FROM exercises WHERE program_id = ? ORDER BY exercise_order ASC",
      [_programId],
    )).map((map) => ExerciseModel.fromMap(map)).toList();

    List<Step> steps = [];

    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];
      final metric = exercise.duration == null
          ? ExerciseMetric.repetition
          : ExerciseMetric.duration;

      steps.add(
        Step(stepType: StepType.preparation, value: exercise.preparation),
      );

      steps.add(
        Step(
          stepType: switch (metric) {
            ExerciseMetric.repetition => StepType.repetition,
            ExerciseMetric.duration => StepType.duration,
          },
          value: switch (metric) {
            ExerciseMetric.repetition => exercise.repetition!,
            ExerciseMetric.duration => exercise.duration!,
          },
        ),
      );
    }

    return ProgramRunModel(
      isFinished: false,
      exercises: exercises,
      currentExerciseIdx: 0,
      currentStepIdx: 0,
      steps: steps,
      isRunning: false,
      remainingSecs: 0,
      extraSecs: 0,
    );
  }

  void skipPreparation() {
    if (!state.hasValue) return;
    final value = state.requireValue;

    if (value.currentStep.stepType != StepType.preparation) {
      return;
    }

    _timer?.cancel();
    _stopwatch.reset();

    state = AsyncValue.data(
      value.copyWith(
        currentStepIdx: value.currentStepIdx + 1,
        extraSecs: 0,
        isRunning: value.currentExercise.repetition == null,
      ),
    );

    if (value.currentExercise.repetition == null) {
      start();
    }
  }

  void skipDuration() {
    if (!state.hasValue) return;

    final value = state.requireValue;

    if (value.currentStep.stepType != StepType.duration) {
      return;
    }

    _timer?.cancel();
    _stopwatch.reset();

    _advanceStep();
    start();
  }

  void prevExercise() {
    final value = state.requireValue;

    if (value.currentExerciseIdx == 0) return;

    _timer?.cancel();
    _stopwatch.reset();

    final stepBack = value.currentStep.stepType == StepType.preparation ? 2 : 3;

    state = AsyncValue.data(
      value.copyWith(
        currentExerciseIdx: value.currentExerciseIdx - 1,
        currentStepIdx: value.currentStepIdx - stepBack,
        extraSecs: 0,
        isRunning: true,
      ),
    );

    start();
  }

  void nextExercise() {
    final value = state.requireValue;

    if (value.isLastExercise) {
      state = AsyncValue.data(value.copyWith(isFinished: true));
      return;
    }

    _stopwatch
      ..reset()
      ..start();
    _timer?.cancel();

    state = AsyncValue.data(
      value.copyWith(
        currentExerciseIdx: value.currentExerciseIdx + 1,
        currentStepIdx: (value.currentStep.stepType == StepType.preparation)
            ? value.currentStepIdx + 2
            : value.currentStepIdx + 1,
        extraSecs: 0,
        isRunning: true,
      ),
    );

    start();
  }

  void playPause() {
    final value = state.requireValue;

    if (value.isRunning) {
      _stopwatch.stop();
    } else {
      _stopwatch.start();
    }

    state = AsyncValue.data(value.copyWith(isRunning: !value.isRunning));
  }

  void addPrepTime() {
    final value = state.requireValue;

    if (value.currentStep.stepType != StepType.preparation) {
      return;
    }

    state = AsyncValue.data(
      value.copyWith(
        extraSecs: value.extraSecs + 20,
        remainingSecs: value.remainingSecs + 20,
      ),
    );
  }

  int _currentStepTargetSecs(ProgramRunModel value) {
    return value.currentStep.value + value.extraSecs;
  }

  Future<void> start() async {
    _timer?.cancel();

    _stopwatch
      ..reset()
      ..start();

    final value = await future;

    state = AsyncValue.data(
      value.copyWith(
        remainingSecs: _currentStepTargetSecs(value),
        isRunning: true,
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      _onTick();
    });
  }

  void _onTick() {
    final value = state.requireValue;

    if (!value.isRunning) return;

    final elapsed = _stopwatch.elapsed.inSeconds;
    final target = _currentStepTargetSecs(value);
    final remaining = (target - elapsed).clamp(
      0,
      target,
    ); 

    // UI update
    state = AsyncValue.data(value.copyWith(remainingSecs: remaining));


    if (target - elapsed <= 3 && target - elapsed > 0) {
      final player = AudioPlayer();

      player.play(AssetSource("audio/beep.mp3"));
    }

    if (target - elapsed <= 0 &&
        value.currentStep.stepType != StepType.preparation) {
      final player = AudioPlayer();

      player.play(AssetSource("audio/bell.mp3"));
    }

    if (target - elapsed <= 0 &&
        value.currentStep.stepType == StepType.preparation) {
      final player = AudioPlayer();

      player.play(AssetSource("audio/whistle.mp3"));
    }

    if (elapsed >= target) {
      _advanceStep();

      final value = state.requireValue;

      final elapsed = _stopwatch.elapsed.inSeconds;
      final target = _currentStepTargetSecs(value);
      final remaining = (target - elapsed).clamp(
        0,
        target,
      );

      state = AsyncValue.data(value.copyWith(remainingSecs: remaining));
    }
  }

  void _advanceStep() {
    final value = state.requireValue;

    _stopwatch
      ..stop()
      ..reset();

    if (value.currentStep.stepType == StepType.preparation) {
      state = AsyncValue.data(
        value.copyWith(
          currentStepIdx: value.currentStepIdx + 1,
          extraSecs: 0,
          isRunning: value.currentExercise.repetition == null,
        ),
      );

      if (value.currentExercise.repetition == null) {
        _stopwatch.start();
      }

      return;
    }

    if (value.currentStep.stepType == StepType.duration) {
      if (value.isLastExercise) {
        _timer?.cancel();
        state = AsyncValue.data(value.copyWith(isFinished: true));
        return;
      }

      state = AsyncValue.data(
        value.copyWith(
          currentExerciseIdx: value.currentExerciseIdx + 1,
          currentStepIdx: value.currentStepIdx + 1,
          extraSecs: 0,
          isRunning: true,
        ),
      );

      _stopwatch.start();
    }
  }
}
