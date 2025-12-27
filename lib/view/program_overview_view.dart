import 'package:custom_exercise/provider/program_overview_provider.dart';
import 'package:custom_exercise/view/edit_program_view.dart';
import 'package:custom_exercise/view/program_run_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO change into preview
class ProgramOverviewView extends StatelessWidget {
  const ProgramOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ProgramOverviewProvider>(
          builder: (context, value, child) {
            return Text(value.chosenProgram!.name);
          },
        ),
        actions: [
          Consumer<ProgramOverviewProvider>(
            builder: (context, value, child) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Consumer<ProgramOverviewProvider>(
                        builder: (context, value, _) {
                          return EditProgramView(value.chosenProgram!);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Consumer<ProgramOverviewProvider>(
            builder: (context, value, child) {
              return ListView.builder(
                itemCount: value.exercises.length,
                itemBuilder: (context, idx) {
                  final exercise = value.exercises[idx];
                  return ListTile(
                    title: Text(exercise.name),
                    subtitle: Text("Preparation: ${exercise.preparation} secs"),
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
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProgramRunView(),
                    ),
                  );
                },
                child: Text("Start"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
