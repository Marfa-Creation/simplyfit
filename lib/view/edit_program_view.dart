import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:custom_exercise/provider/program_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:custom_exercise/view/add_exercise_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProgramView extends StatefulWidget {
  const EditProgramView(this.program, {super.key});

  final ProgramModel program;

  @override
  State<EditProgramView> createState() => _EditProgramViewState();
}

class _EditProgramViewState extends State<EditProgramView> {
  final _programNameController = TextEditingController();
  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String? errorText;

  @override
  void initState() {
    _programNameController.text = widget.program.name;
    super.initState();
  }

  @override
  void dispose() {
    _programNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Consumer(
        builder: (context, ref, child) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, _) {
              if (!_formKey.currentState!.validate()) return;
              if (didPop) {
                return;
              }

              ref
                  .read(programProvider.notifier)
                  .renameProgram(
                    widget.program.id!,
                    _programNameController.text,
                  );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 63,
                actions: [],
                title: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "This field cannot be empty";
                        }

                        final programs = ref.read(programProvider);

                        if (!programs.hasValue) return null;

                        bool exists = false;

                        for (var element in programs.requireValue) {
                          if (element.name.trim() == value.trim() &&
                              element.id !=
                                  ref.read(selectedProgramProvider)!.id) {
                            exists = true;
                          }
                        }

                        if (exists) {
                          return "The program already exists";
                        }

                        return null;
                      },
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(),
                      controller: _programNameController,
                      focusNode: _focusNode,
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton.small(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddEditExerciseView(
                        mode: FormModeAdd(),
                        programId: widget.program.id!,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
              body: Consumer(
                builder: (context, ref, child) {
                  final exercises = ref.watch(
                    exerciseProvider(widget.program.id!),
                  );

                  return exercises.when(
                    data: (List<ExerciseModel> data) {
                      return ReorderableListView.builder(
                        onReorder: (oldIdx, newIdx) {
                          ref
                              .read(
                                exerciseProvider(widget.program.id!).notifier,
                              )
                              .onReorder(widget.program.id!, oldIdx, newIdx);
                        },
                        itemCount: data.length,
                        itemBuilder: (context, idx) {
                          final exercise = data[idx];
                          return Padding(
                            key: ValueKey(exercise.id),
                            padding: EdgeInsets.only(
                              bottom: data.length - 1 == idx ? 55 : 0,
                            ),
                            child: ListTile(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SafeArea(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.edit),
                                            title: const Text('Edit'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          AddEditExerciseView(
                                                            mode: FormModeEdit(
                                                              exercise,
                                                            ),
                                                            programId: widget
                                                                .program
                                                                .id!,
                                                          ),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Delete'),
                                            onTap: () {
                                              Navigator.pop(context);
                                              ref
                                                  .read(
                                                    exerciseProvider(
                                                      widget.program.id!,
                                                    ).notifier,
                                                  )
                                                  .deleteExercise(exercise.id!);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              title: Text(exercise.name),
                              subtitle: Text(
                                "Preparation: ${formatSecs(exercise.preparation)}",
                              ),
                              trailing: exercise.repetition != null
                                  ? SizedBox(
                                      width: 50,
                                      child: Row(
                                        crossAxisAlignment: .center,
                                        mainAxisAlignment: .end,
                                        children: [
                                          Icon(
                                            size: 18,
                                            Icons.close,
                                            color: Color(0xfff7f7f7),
                                          ),
                                          Text(
                                            style: TextStyle(fontSize: 18),
                                            "${exercise.repetition!}",
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      style: TextStyle(fontSize: 18),
                                      formatSecs(exercise.duration!),
                                    ),
                            ),
                          );
                        },
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
            ),
          );
        },
      ),
    );
  }
}
