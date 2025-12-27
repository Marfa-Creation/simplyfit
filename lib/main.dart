import 'package:custom_exercise/provider/edit_program_provider.dart';
import 'package:custom_exercise/provider/home_provider.dart';
import 'package:custom_exercise/provider/program_overview_provider.dart';
import 'package:custom_exercise/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final path = join(await getDatabasesPath(), "db");

  final db = await openDatabase(
    path,
    version: 1,
    onConfigure: (db) async {
      await db.execute('PRAGMA foreign_keys = ON');
    },
    onCreate: (db, ver) async {
      await db.transaction((trans) async {
        await trans.execute("""
          CREATE TABLE IF NOT EXISTS programs (
            id INTEGER PRIMARY KEY,
            name TEXT UNIQUE NOT NULL CHECK(length(name) >= 1)
          )
        """);

        await trans.execute("""
          CREATE TABLE IF NOT EXISTS exercises (
            id INTEGER PRIMARY KEY,
            program_id INTEGER NOT NULL,
            preparation INTEGER NOT NULL, -- time (in seconds) before the exercise start
            exercise_order INTEGER NOT NULL, -- UNIQUE is omitted here because of the need for a deferred check. The value must still UNIQUE. starts from 0
            repetition INTEGER,
            duration INTEGER,
            name TEXT NOT NULL CHECK(length(exercises.name) >= 1),
            FOREIGN KEY(program_id) REFERENCES programs(id) ON DELETE CASCADE,
            CONSTRAINT one_must_be_null CHECK
            (
              (repetition IS NOT NULL) AND (duration IS NULL)
               OR
              (duration IS NOT NULL) AND (repetition IS NULl)
            )
          )
        """);
      });
    },
  );

  runApp(
    MultiProvider(
      providers: [
        // Provider.value(value: db),
        ChangeNotifierProvider(create: (_) => HomeProvider(db)..init()),
        ChangeNotifierProvider(create: (_) => ProgramOverviewProvider(db, null)..init()),
        ChangeNotifierProvider(create: (_) => EditProgramProvider(db)..init()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomeView());
  }
}
