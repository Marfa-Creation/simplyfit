import 'dart:async';
import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditExerciseView extends StatefulWidget {
  const AddEditExerciseView({
    super.key,
    required this.programId,
    required this.mode,
  });

  final int programId;
  final FormMode mode;

  @override
  State<AddEditExerciseView> createState() => _AddEditExerciseViewState();
}

class _AddEditExerciseViewState extends State<AddEditExerciseView> {
  final exerciseNameController = TextEditingController();
  final metricInputController = TextEditingController();
  final preparationController = TextEditingController.fromValue(
    TextEditingValue(text: "0"),
  );
  ExerciseMetric selectedMetric = ExerciseMetric.repetition;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    metricInputController.addListener(() {
      String text = metricInputController.text;

      if (text.length > 1 && text.startsWith('0')) {
        metricInputController.text = text.replaceFirst(RegExp(r'^0+'), '');
        metricInputController.selection = TextSelection.fromPosition(
          TextPosition(offset: metricInputController.text.length),
        );
      }
    });

    preparationController.addListener(() {
      String text = preparationController.text;

      if (text.length > 1 && text.startsWith('0')) {
        preparationController.text = text.replaceFirst(RegExp(r'^0+'), '');
        preparationController.selection = TextSelection.fromPosition(
          TextPosition(offset: preparationController.text.length),
        );
      }
    });

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
          Consumer(
            builder: (context, ref, child) {
              return TextButton(
                onPressed: () async {

                  if (!_formKey.currentState!.validate()) return;

                  switch (widget.mode) {
                    case FormModeAdd _:
                      {
                        ref
                            .read(exerciseProvider(widget.programId).notifier)
                            .addExercise(
                              ExerciseModel(
                                id: null,
                                programId: widget.programId,
                                preparation: int.parse(
                                  preparationController.text,
                                ),
                                exerciseOrder:
                                    (await ref.read<
                                          FutureOr<List<ExerciseModel>>
                                        >(
                                          exerciseProvider(
                                            widget.programId,
                                          ).future,
                                        ))
                                        .length,
                                name: exerciseNameController.text,
                                duration:
                                    selectedMetric == ExerciseMetric.duration
                                    ? int.parse(metricInputController.text)
                                    : null,
                                repetition:
                                    selectedMetric == ExerciseMetric.repetition
                                    ? int.parse(metricInputController.text)
                                    : null,
                              ),
                            );
                      }
                    case FormModeEdit editMode:
                      {
                        ref
                            .read(exerciseProvider(widget.programId).notifier)
                            .editExercise(
                              editMode.selectedExercise.id!,
                              ExerciseModel(
                                id: editMode.selectedExercise.id!,
                                programId: widget.programId,
                                preparation: int.parse(
                                  preparationController.text,
                                ),
                                exerciseOrder:
                                    (await ref.read<
                                          FutureOr<List<ExerciseModel>>
                                        >(
                                          exerciseProvider(
                                            widget.programId,
                                          ).future,
                                        ))
                                        .length,
                                name: exerciseNameController.text,
                                duration:
                                    selectedMetric == ExerciseMetric.duration
                                    ? int.parse(metricInputController.text)
                                    : null,
                                repetition:
                                    selectedMetric == ExerciseMetric.repetition
                                    ? int.parse(metricInputController.text)
                                    : null,
                              ),
                            );
                      }
                  }

                  if(context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child: Text(switch (widget.mode) {
                  FormModeAdd _ => "Add",
                  FormModeEdit _ => "Edit",
                }),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Name",
                ),
                controller: exerciseNameController,
              ),
              SizedBox(height: 11),
              Row(
                crossAxisAlignment: .start,
                spacing: 6,
                children: [
                  Expanded(
                    flex: 11,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }
                        if (int.parse(value) <= 0) {
                          return "The value must be greater than 0";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        errorMaxLines: 2,
                        border: OutlineInputBorder(),
                      ),
                      controller: metricInputController,
                    ),
                  ),
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
                ],
              ),
              SizedBox(height: 11),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field cannot be empty";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Preparation Time (secs)",
                ),
                controller: preparationController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
