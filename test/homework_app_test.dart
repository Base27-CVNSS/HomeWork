import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:homework/app/homework_app.dart';
import 'package:homework/data/workspace_store.dart';
import 'package:homework/state/workspace_controller.dart';

void main() {
  test('HomeWork application widget can be constructed', () {
    final WorkspaceController controller = WorkspaceController(
      store: WorkspaceStore(),
    );
    final HomeWorkApp application = HomeWorkApp(controller: controller);

    expect(application, isA<Widget>());
    expect(application.controller, same(controller));

    controller.dispose();
  });
}
