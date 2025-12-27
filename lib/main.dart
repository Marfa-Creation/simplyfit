import 'package:custom_exercise/provider/db_provider.dart';
import 'package:custom_exercise/theme.dart';
import 'package:custom_exercise/util.dart';
import 'package:custom_exercise/view/program_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "JetBrains Mono", "JetBrains Mono");
    MaterialTheme theme = MaterialTheme(textTheme);
    return _EagerInitialization(child: MaterialApp(theme: theme.dark(), home: ProgramView()));
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(dbProvider);
    return child;
  }
}
