class ExerciseModel {
  int? id;
  int programId;
  int preparation;
  int exerciseOrder;
  int? repetition;
  int? duration;
  String name;

  ExerciseModel({
    required this.id,
    required this.programId,
    required this.preparation,
    required this.exerciseOrder,
    required this.name,
    required this.duration,
    required this.repetition,
  });

  ExerciseModel copyWith({
    int? id,
    int? programId,
    int? preparation,
    int? exerciseOrder,
    String? name,
    int? duration,
    int? repetition,
  }) {
    return ExerciseModel(
      id: id ?? id,
      programId: programId ?? this.programId,
      preparation: preparation ?? this.preparation,
      exerciseOrder: exerciseOrder ?? this.exerciseOrder,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      repetition: repetition ?? this.repetition,
    );
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map["id"],
      programId: map["program_id"],
      name: map["name"],
      preparation: map["preparation"],
      exerciseOrder: map["exercise_order"],
      repetition: map["repetition"],
      duration: map["duration"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "program_id": programId,
      "name": name,
      "preparation": preparation,
      "exercise_order": exerciseOrder,
      "repetition": repetition,
      "duration": duration,
    };
  }
}
