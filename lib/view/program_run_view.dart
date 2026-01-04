import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/program_run_model.dart';
import 'package:custom_exercise/provider/program_run_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ProgramRunView extends ConsumerStatefulWidget {
  const ProgramRunView({super.key});

  @override
  ConsumerState<ProgramRunView> createState() => _ProgramRunViewState();
}

class _ProgramRunViewState extends ConsumerState<ProgramRunView> {
  @override
  void initState() {
    WakelockPlus.enable();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .watch(
            programRunProvider(ref.read(selectedProgramProvider)!.id!).notifier,
          )
          .start();
    });
    super.initState();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Color(0xff24283b),
      body: Consumer(
        builder: (context, ref, child) {
          final exercise = ref.watch(
            programRunProvider(ref.read(selectedProgramProvider)!.id!),
          );

          return exercise.when(
            data: (ProgramRunModel data) {
              final currentExercise = data.currentExercise;

              return data.isFinished
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 96),
                            const SizedBox(height: 24),
                            const Text(
                              'Workout Complete!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Great job finishing your workout.\nTake a moment to breathe and recover.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  child: Text(
                                    'Back',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: .center,
                      crossAxisAlignment: .center,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                              ),
                              currentExercise.name,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xffc0caf5),
                              borderRadius: BorderRadiusGeometry.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: .center,
                              mainAxisAlignment: .center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment: .center,
                                    mainAxisAlignment: .center,
                                    children: [
                                      if (data.currentStep.stepType ==
                                          StepType.preparation)
                                        Text(
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff24283b),
                                          ),
                                          "Preparation",
                                        ),
                                      Row(
                                        mainAxisAlignment: .center,
                                        crossAxisAlignment: .center,
                                        children: [
                                          if (data.currentStep.stepType ==
                                              StepType.repetition)
                                            Icon(
                                              size: 35,
                                              Icons.close,
                                              color: Color(0xff24283b),
                                            ),
                                          Text(
                                            style: TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xff24283b),
                                            ),
                                            data.currentStep.stepType ==
                                                    StepType.repetition
                                                ? data
                                                      .currentExercise
                                                      .repetition!
                                                      .toString()
                                                : formatSecs(
                                                    data.remainingSecs,
                                                  ),
                                            // data.remainingSecs.toString()
                                          ),
                                        ],
                                      ),

                                      if (data.currentStep.stepType ==
                                          StepType.preparation)
                                        Row(
                                          crossAxisAlignment: .center,
                                          mainAxisAlignment: .center,
                                          children: [
                                            SizedBox(
                                              width: 90,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xff24283b,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  ref
                                                      .watch(
                                                        programRunProvider(
                                                          ref
                                                              .read(
                                                                selectedProgramProvider,
                                                              )!
                                                              .id!,
                                                        ).notifier,
                                                      )
                                                      .addPrepTime();
                                                },
                                                child: Text("+20"),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            SizedBox(
                                              width: 90,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Color(
                                                    0xff24283b,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  ref
                                                      .watch(
                                                        programRunProvider(
                                                          ref
                                                              .read(
                                                                selectedProgramProvider,
                                                              )!
                                                              .id!,
                                                        ).notifier,
                                                      )
                                                      .skipPreparation();
                                                },
                                                child: Text("Skip"),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .center,
                                    children: [
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Color(0xff7aa2f7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  8,
                                                ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final notifier = ref.read(
                                            programRunProvider(
                                              ref
                                                  .read(
                                                    selectedProgramProvider,
                                                  )!
                                                  .id!,
                                            ).notifier,
                                          );

                                          notifier.prevExercise();

                                          final isRunning = (await ref.read(
                                            programRunProvider(
                                              ref
                                                  .read(
                                                    selectedProgramProvider,
                                                  )!
                                                  .id!,
                                            ).future,
                                          )).isRunning;

                                          if (!isRunning) {
                                            notifier.playPause();
                                          }
                                        },
                                        icon: Icon(
                                          color: Color(0xff24283b),
                                          Icons.skip_previous,
                                        ),
                                      ),

                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Color(0xff7aa2f7),
                                          minimumSize: Size(150, 0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  8,
                                                ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (data.currentStep.stepType ==
                                              StepType.repetition) {
                                            ref
                                                .watch(
                                                  programRunProvider(
                                                    ref
                                                        .read(
                                                          selectedProgramProvider,
                                                        )!
                                                        .id!,
                                                  ).notifier,
                                                )
                                                .nextExercise();
                                          } else {
                                            ref
                                                .watch(
                                                  programRunProvider(
                                                    ref
                                                        .read(
                                                          selectedProgramProvider,
                                                        )!
                                                        .id!,
                                                  ).notifier,
                                                )
                                                .playPause();
                                          }
                                        },
                                        icon: Icon(
                                          color: Color(0xff24283b),
                                          switch (data.isRunning) {
                                            true => Icons.pause,
                                            false => Icons.play_arrow,
                                          },
                                        ),
                                      ),
                                      IconButton.filled(
                                        style: IconButton.styleFrom(
                                          backgroundColor: Color(0xff7aa2f7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  8,
                                                ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          final notifier = ref.read(
                                            programRunProvider(
                                              ref
                                                  .read(
                                                    selectedProgramProvider,
                                                  )!
                                                  .id!,
                                            ).notifier,
                                          );

                                          notifier.nextExercise();

                                          final isRunning = (await ref.read(
                                            programRunProvider(
                                              ref
                                                  .read(
                                                    selectedProgramProvider,
                                                  )!
                                                  .id!,
                                            ).future,
                                          )).isRunning;

                                          if (!isRunning) {
                                            notifier.playPause();
                                          }
                                        },
                                        icon: Icon(
                                          color: Color(0xff24283b),
                                          Icons.skip_next,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
            },
            error: (Object error, StackTrace stackTrace) {
              return Center(child: Text(error.toString()));
            },
            loading: () {
              return Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
