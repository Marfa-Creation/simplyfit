import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/program_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:custom_exercise/view/edit_program_view.dart';
import 'package:custom_exercise/view/program_preview_view.dart';
import 'package:flutter/material.dart';
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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Form(
              key: _formKey,
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
                          if (!_formKey.currentState!.validate()) {
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
                          if(element.name.trim() == value.trim()) {
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
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
      ),
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
    );
  }
}
