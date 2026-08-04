import 'package:flutter/material.dart';
import 'package:homework/app/homework_app.dart';
import 'package:homework/data/workspace_store.dart';
import 'package:homework/state/workspace_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final WorkspaceController controller = WorkspaceController(
    store: WorkspaceStore(),
  );
  await controller.load();

  runApp(HomeWorkApp(controller: controller));
}
