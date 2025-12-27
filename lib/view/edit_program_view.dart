import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/edit_program_provider.dart';
import 'package:custom_exercise/provider/home_provider.dart';
import 'package:custom_exercise/provider/program_overview_provider.dart';
import 'package:custom_exercise/view/add_exercise_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class EditProgramView extends StatefulWidget {
  const EditProgramView(this.program, {super.key});

  final ProgramModel program;

  @override
  State<EditProgramView> createState() => _EditProgramViewState();
}

class _EditProgramViewState extends State<EditProgramView> {
  final _titleController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    _titleController.text = widget.program.name;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            // IconButton(
            //   onPressed: () => _focusNode.requestFocus(),
            //   icon: Icon(Icons.edit),
            // ),
          ],
          title: Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey, width: 1)),
            ),
            child: EditableText(
              controller: _titleController,
              focusNode: _focusNode,
              style: Theme.of(context).textTheme.titleLarge!,
              cursorColor: Color(0xff24283b),
              backgroundCursorColor: CupertinoColors.inactiveGray,
            ),
          ),
        ),
        floatingActionButton: Consumer<EditProgramProvider>(
          builder: (context, value, child) {
            return FloatingActionButton.small(
              onPressed: () {
                // final editoProgramProvider = context.read<EditProgramProvider>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExerciseView(
                      mode: FormModeAdd(),
                      programId: widget.program.id!,
                      editProgramProvider: value,
                    ),
                  ),
                );
                // showDialog(
                //   context: context,
                //   builder: (context) => AlertDialog(
                //     title: Text("Add exercise"),
                //     actions: [
                //       TextButton(
                //         onPressed: () {
                //           Navigator.pop(context);
                //         },
                //         child: Text("Cancel"),
                //       ),
                //       TextButton(
                //         onPressed: () {},
                //         child: Text("Add"),
                //       ),
                //     ],
                //     content: SingleChildScrollView(
                //       padding: EdgeInsets.only(
                //         bottom: MediaQuery.of(context).viewInsets.bottom,
                //       ),
                //       child: ,
                //     ),
                //   ),
                // );
              },
              child: Icon(Icons.add),
            );
          },
        ),
        body: Consumer3<EditProgramProvider, ProgramOverviewProvider, HomeProvider>(
          builder:
              (
                context,
                editProgramProvider,
                programOverviewProvider,
                homeProvider,
                child,
              ) {
                return PopScope(
                  onPopInvokedWithResult: (_, _) {
                    programOverviewProvider.chosenProgram = ProgramModel(
                      id: widget.program.id!,
                      name: _titleController.text,
                    );

                    programOverviewProvider.updateExercises(
                      editProgramProvider.exercises,
                    );

                    homeProvider.renameProgram(
                      // widget.program.copyWith(name: _titleController.text),
                      widget.program.id!,
                      _titleController.text,
                    );
                  },
                  child: ReorderableListView.builder(
                    onReorder: (oldIdx, newIdx) {
                      context.read<EditProgramProvider>().onReorder(
                        widget.program.id!,
                        oldIdx,
                        newIdx,
                      );

                      // }
                      // print("$oldIdx -> $newIdx");
                      // throw UnimplementedError("when when");
                    },
                    itemCount: editProgramProvider.exercises.length,
                    itemBuilder: (context, idx) {
                      final exercise = editProgramProvider.exercises[idx];
                      return ListTile(
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
                                        // onEdit();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddExerciseView(
                                                  mode: FormModeEdit(exercise),
                                                  programId: widget.program.id!,
                                                  editProgramProvider: context
                                                      .read<
                                                        EditProgramProvider
                                                      >(),
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
                                        context.read<EditProgramProvider>().deleteExercise(exercise.id!);
                                        // onDelete();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ); // ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration.inf, content: Row(),));
                        },
                        key: ValueKey(exercise.id),
                        title: Text(exercise.name),
                        subtitle: Text(
                          "Preparation: ${exercise.preparation} secs",
                        ),
                        trailing: exercise.repetition != null
                            ? Text(
                                style: TextStyle(fontSize: 18),
                                "${exercise.repetition!} reps",
                              )
                            : Text(
                                style: TextStyle(fontSize: 18),
                                "${exercise.duration} secs",
                              ),
                      );
                    },
                  ),
                );
              },
        ),
      ),
    );
  }
}
