class ProgramModel {
  final int? id;
  final String name;

  ProgramModel({required this.id, required this.name});

  factory ProgramModel.fromMap(Map<String, dynamic> map) {
    return ProgramModel(id: map["id"], name: map["name"]);
  }

  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }

  ProgramModel copyWith({int? id, String? name}) {
    return ProgramModel(id: id ?? this.id, name: name ?? this.name);
  }
}
