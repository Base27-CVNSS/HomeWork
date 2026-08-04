import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework/app/homework_app.dart';
import 'package:homework/data/workspace_store.dart';
import 'package:homework/state/workspace_controller.dart';

void main() {
  testWidgets('HomeWork renders the workspace shell', (
    WidgetTester tester,
  ) async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'homework-widget-test-',
    );
    addTearDown(() => directory.delete(recursive: true));

    final WorkspaceController controller = WorkspaceController(
      store: WorkspaceStore(directory: directory),
    );
    await controller.load();

    await tester.pumpWidget(HomeWorkApp(controller: controller));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byIcon(Icons.space_dashboard_rounded), findsOneWidget);
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    controller.dispose();
  });
}
