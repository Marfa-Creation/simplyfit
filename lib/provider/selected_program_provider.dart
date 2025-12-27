import 'package:custom_exercise/model/program_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedProgramProvider = NotifierProvider(
  SelectedProgramNotifier.new,
);

class SelectedProgramNotifier extends Notifier<ProgramModel?> {
  @override
  ProgramModel? build() {
    return null;
  }

  void selectProgram(ProgramModel program) => state = program;
}
