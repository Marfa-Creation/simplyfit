import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ProgramRunProvider extends ChangeNotifier {
  final Database _db;

  ProgramRunProvider(this._db);

  void init() async {
    
  }
}
