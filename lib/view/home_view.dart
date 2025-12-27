import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/home_provider.dart';
import 'package:custom_exercise/provider/program_overview_provider.dart';
import 'package:custom_exercise/view/edit_program_view.dart';
import 'package:custom_exercise/view/program_overview_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final programNameController = TextEditingController();
  final menuController = MenuController();

  @override
  void dispose() {
    programNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Create Program"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<HomeProvider>().createProgram(
                          ProgramModel(
                            id: null,
                            name: programNameController.text,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text("Create"),
                    ),
                  ],
                  content: TextField(
                    style: TextStyle(),
                    controller: programNameController,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.programs.length,
            itemBuilder: (program, idx) {
              final program = value.programs[idx];

              return ListTile(
                onTap: () {
                  context.read<ProgramOverviewProvider>().chosenProgram =
                      program;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProgramOverviewView(),
                    ),
                  );
                },
                tileColor: Colors.red,
                title: Text(program.name),
                trailing: MenuAnchor(
                  controller: menuController,
                  // builder: (ctx, controller, _) {
                  // controller.open();
                  // },
                  style: MenuStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.pink),
                  ),
                  alignmentOffset: Offset(-10, 0),
                  menuChildren: [
                    Consumer<HomeProvider>(
                      builder: (_, value, child) {
                        return MenuItemButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProgramView(program),
                              ),
                            );
                          },
                          child: Text("Edit"),
                        );
                      },
                    ),
                    Consumer<HomeProvider>(
                      builder: (_, value, child) {
                        return MenuItemButton(
                          onPressed: () async {
                            final confirmation =
                                await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text("Delete"),
                                        content: Text("This action cannot be undone"),
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
                              value.deleteProgram(program.id!);
                            }
                          },
                          child: Text("Delete"),
                        );
                      },
                    ),
                  ],
                  child: IconButton(
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
              );
            },
          );
        },
      ),
    );
  }
}
