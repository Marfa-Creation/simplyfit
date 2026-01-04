import 'package:custom_exercise/core.dart';
import 'package:custom_exercise/model/exercise_model.dart';
import 'package:custom_exercise/model/program_model.dart';
import 'package:custom_exercise/provider/exercise_provider.dart';
import 'package:custom_exercise/provider/selected_program_provider.dart';
import 'package:custom_exercise/view/edit_program_view.dart';
import 'package:custom_exercise/view/program_run_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgramPreviewView extends StatelessWidget {
  const ProgramPreviewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(
          builder: (context, ref, child) {
            return Text(ref.watch(selectedProgramProvider)!.name);
          },
        ),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              return IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProgramView(
                        ref.read<ProgramModel?>(selectedProgramProvider)!,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final exercises = ref.watch(
            exerciseProvider(
              ref.read<ProgramModel?>(selectedProgramProvider)!.id!,
            ),
          );

          return exercises.when(
            data: (List<ExerciseModel> data) {
              return Stack(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 50),
                        child: ListView.separated(
                          itemCount: data.length,
                          itemBuilder: (context, idx) {
                            final exercise = data[idx];
                            return ListTile(
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
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                          },
                        ),
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
                        onPressed: data.isEmpty
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        ProgramRunView(),
                                  ),
                                );
                              },
                        child: Text("Start"),
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
