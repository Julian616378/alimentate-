import 'package:flutter/material.dart';
import '../state/app_state.dart';
import 'widgets/main_scaffold.dart';

class AlimentateApp extends StatefulWidget {
  const AlimentateApp({super.key});

  @override
  State<AlimentateApp> createState() => _AlimentateAppState();
}

class _AlimentateAppState extends State<AlimentateApp> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appState,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainScaffold(appState: _appState),
        );
      },
    );
  }
}