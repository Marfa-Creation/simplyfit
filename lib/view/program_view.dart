import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/program_import_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:custom_exercise/provider/program_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:custom_exercise/view/edit_program_view.dart';
import 'package:custom_exercise/view/program_preview_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramView extends StatefulWidget {
  const ProgramView({super.key});

  @override
  State<ProgramView> createState() => _ProgramViewState();
}

class _ProgramViewState extends State<ProgramView> {
  final programNameController = TextEditingController();

  @override
  void dispose() {
    programNameController.dispose();
    super.dispose();
  }

  final _formKeyCreate = GlobalKey<FormState>();
  final _formKeyImport = GlobalKey<FormState>();
  final _expandableFabKey = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _expandableFabKey.currentState?.close();
      },
      child: Scaffold(
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _expandableFabKey,
          type: ExpandableFabType.up,
          openButtonBuilder: RotateFloatingActionButtonBuilder(
            child: Icon(Icons.add),
          ),
      
          children: [
            FloatingActionButton.small(
              heroTag: null,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Form(
                    key: _formKeyCreate,
                    child: AlertDialog(
                      title: Text("Create Program"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            return TextButton(
                              onPressed: () {
                                if (!_formKeyCreate.currentState!.validate()) {
                                  return;
                                }
      
                                ref
                                    .read(programProvider.notifier)
                                    .createProgram(
                                      ProgramModel(
                                        id: null,
                                        name: programNameController.text.trim(),
                                      ),
                                    );
                                Navigator.pop(context);
                              },
                              child: Text("Create"),
                            );
                          },
                        ),
                      ],
                      content: Consumer(
                        builder: (context, ref, child) {
                          return TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "This field cannot be empty";
                              }
      
                              final programs = ref.read(programProvider);
      
                              if (!programs.hasValue) return null;
      
                              bool exists = false;
      
                              for (var element in programs.requireValue) {
                                if (element.name.trim() == value.trim()) {
                                  exists = true;
                                }
                              }
      
                              if (exists) {
                                return "The program already exists";
                              }
      
                              return null;
                            },
                            style: TextStyle(),
                            controller: programNameController,
                          );
                        },
                      ),
                    ),
                  ),
                );
      
                programNameController.clear();
                _expandableFabKey.currentState?.close();
              },
              child: Icon(Icons.add),
            ),
            Consumer(
              builder: (context, ref, child) {
                return FloatingActionButton.small(
                  heroTag: null,
                  onPressed: () async {
                    final ProgramImportModel? imported;
      
                    try {
                      imported = await Import.importProgram();
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Color(0xfff7768e),
                            content: Text("Cannot import file, invalid file"),
                          ),
                        );
                      }
                      _expandableFabKey.currentState?.close();
                      return;
                    }
      
                    // aborted
                    if (imported == null) return;
      
                    final programName = imported.name;
                    final exercises = imported.exercises;
      
                    if (!context.mounted) return;
      
                    // Let the user decide whether to keep the programName or not
                    programNameController.text = programName;
                    showDialog(
                      context: context,
                      builder: (context) => Form(
                        key: _formKeyImport,
                        child: AlertDialog(
                          title: Text("Import Program"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                return TextButton(
                                  onPressed: () async {
                                    if (!_formKeyImport.currentState!
                                        .validate()) {
                                      return;
                                    }
      
                                    final programId = (await ref
                                        .read(programProvider.notifier)
                                        .createProgram(
                                          ProgramModel(
                                            id: null,
                                            name: programNameController.text
                                                .trim(),
                                          ),
                                        ))!;
                                    ref
                                        .read(
                                          exerciseProvider(programId).notifier,
                                        )
                                        .importExercises(exercises);
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text("Import"),
                                );
                              },
                            ),
                          ],
                          content: Consumer(
                            builder: (context, ref, child) {
                              return TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "This field cannot be empty";
                                  }
      
                                  final programs = ref.read(programProvider);
      
                                  if (!programs.hasValue) return null;
      
                                  bool exists = false;
      
                                  for (var element in programs.requireValue) {
                                    if (element.name.trim() == value.trim()) {
                                      exists = true;
                                    }
                                  }
      
                                  if (exists) {
                                    return "The program already exists";
                                  }
      
                                  return null;
                                },
                                style: TextStyle(),
                                controller: programNameController,
                              );
                            },
                          ),
                        ),
                      ),
                    );
      
                    print("close");
                    programNameController.clear();
                    _expandableFabKey.currentState?.close();
                  },
                  child: Icon(Icons.upload),
                );
              },
            ),
          ],
        ),
        appBar: AppBar(),
        body: Consumer(
          builder: (context, ref, child) {
            final programs = ref.watch(programProvider);
      
            return programs.when(
              data: (List<ProgramModel> data) {
                return ListView.separated(
                  itemCount: data.length,
                  itemBuilder: (program, idx) {
                    final program = data[idx];
      
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: data.length - 1 == idx ? 65 : 0,
                      ),
                      child: ListTile(
                        onTap: () {
                          ref
                              .read(selectedProgramProvider.notifier)
                              .selectProgram(program);
      
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProgramPreviewView(),
                            ),
                          );
                        },
                        title: Text(program.name),
                        trailing: MenuAnchor(
                          alignmentOffset: Offset(-10, 0),
                          menuChildren: [
                            MenuItemButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProgramView(program),
                                  ),
                                );
                              },
                              child: Text("Edit"),
                            ),
                            MenuItemButton(
                              onPressed: () async {
                                ref
                                    .read(selectedProgramProvider.notifier)
                                    .selectProgram(program);
      
                                await ref
                                    .read(programProvider.notifier)
                                    .exportSelectedProgram();
                              },
                              child: Text("Export"),
                            ),
                            MenuItemButton(
                              onPressed: () async {
                                final confirmation =
                                    await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: Text("Delete"),
                                            content: Text(
                                              "This action cannot be undone",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, false);
                                                },
                                                child: Text("No"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context, true);
                                                },
                                                child: Text("Yes"),
                                              ),
                                            ],
                                          ),
                                    ) ??
                                    false;
      
                                if (confirmation) {
                                  ref
                                      .read(selectedProgramProvider.notifier)
                                      .selectProgram(program);
                                  ref
                                      .read(programProvider.notifier)
                                      .deleteProgram(program.id!);
                                }
                              },
                              child: Text("Delete"),
                            ),
                          ],
                          builder: (context, menuController, child) => IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {
                              if (!menuController.isOpen) {
                                menuController.open();
                              } else if (menuController.isOpen) {
                                menuController.close();
                              }
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
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
  }
}
