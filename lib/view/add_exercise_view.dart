import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/provider/edit_program_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// TODO: rename to AddEdit
class AddExerciseView extends StatefulWidget {
  const AddExerciseView({
    super.key,
    required this.programId,
    required this.editProgramProvider,
    required this.mode,
  });

  final int programId;
  final EditProgramProvider editProgramProvider;
  final FormMode mode;

  @override
  State<AddExerciseView> createState() => _AddExerciseViewState();
}

class _AddExerciseViewState extends State<AddExerciseView> {
  final exerciseNameController = TextEditingController();
  final metricInputController = TextEditingController();
  final preparationController = TextEditingController.fromValue(
    TextEditingValue(text: "0"),
  );
  ExerciseMetric selectedMetric = ExerciseMetric.repetition;

  @override
  void initState() {
    final mode = widget.mode;
    if (mode is FormModeEdit) {
      final exercise = mode.selectedExercise;
      exerciseNameController.text = exercise.name;
      metricInputController.text = (exercise.duration ?? exercise.repetition)
          .toString();
      preparationController.text = exercise.preparation.toString();
      selectedMetric = exercise.repetition == null
          ? ExerciseMetric.duration
          : ExerciseMetric.repetition;
    }

    super.initState();
  }

  @override
  void dispose() {
    exerciseNameController.dispose();
    metricInputController.dispose();
    preparationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              // final provider = context.read<EditProgramProvider>();
              // widget.editProgramProvider

              switch (widget.mode) {
                case FormModeAdd _:
                  {
                    context.read<EditProgramProvider>().addExercise(
                      ExerciseModel(
                        id: null,
                        programId: widget.programId,
                        preparation: int.parse(preparationController.text),
                        exerciseOrder:
                            widget.editProgramProvider.exercises.length,
                        name: exerciseNameController.text,
                        duration: selectedMetric == ExerciseMetric.duration
                            ? int.parse(metricInputController.text)
                            : null,
                        repetition: selectedMetric == ExerciseMetric.repetition
                            ? int.parse(metricInputController.text)
                            : null,
                      ),
                    );
                  }
                case FormModeEdit editMode:
                  {
                    context.read<EditProgramProvider>().editExercise(
                      editMode.selectedExercise.id!,
                      ExerciseModel(
                        id: editMode.selectedExercise.id!,
                        programId: widget.programId,
                        preparation: int.parse(preparationController.text),
                        exerciseOrder:
                            widget.editProgramProvider.exercises.length,
                        name: exerciseNameController.text,
                        duration: selectedMetric == ExerciseMetric.duration
                            ? int.parse(metricInputController.text)
                            : null,
                        repetition: selectedMetric == ExerciseMetric.repetition
                            ? int.parse(metricInputController.text)
                            : null,
                      ),
                    );
                  }
              }

              Navigator.pop(context);
            },
            child: Text(switch (widget.mode) {
              FormModeAdd _ => "Add",
              FormModeEdit _ => "Edit",
            }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 11,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
              controller: exerciseNameController,
            ),
            Row(
              spacing: 6,
              children: [
                Expanded(
                  flex: 11,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      // labelText: "Preparation Time (secs)",
                    ),
                    controller: metricInputController,
                  ),
                ),
                // Expanded(
                // flex: 10,
                // child:
                DropdownMenu(
                  initialSelection: selectedMetric,
                  onSelected: (metric) => selectedMetric = metric!,
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      label: "reps",
                      value: ExerciseMetric.repetition,
                    ),
                    DropdownMenuEntry(
                      label: "secs",
                      value: ExerciseMetric.duration,
                    ),
                  ],
                ),
                // ),
              ],
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Preparation Time (secs)",
              ),
              controller: preparationController,
            ),
          ],
        ),
      ),
    );
  }
}
