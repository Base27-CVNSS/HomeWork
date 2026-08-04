import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:homework/data/workspace_store.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/state/workspace_controller.dart';

void main() {
  test('controller seeds, adds and persists tasks', () async {
    final Directory directory = await Directory.systemTemp.createTemp(
      'homework-test-',
    );
    addTearDown(() => directory.delete(recursive: true));

    final WorkspaceController controller = WorkspaceController(
      store: WorkspaceStore(directory: directory),
    );
    await controller.load();
    expect(controller.tasks, hasLength(4));

    await controller.addTask(
      title: 'Công việc kiểm thử',
      project: 'Cá nhân',
      priority: TaskPriority.normal,
    );
    expect(controller.tasks, hasLength(5));

    final WorkspaceController restored = WorkspaceController(
      store: WorkspaceStore(directory: directory),
    );
    await restored.load();
    expect(
      restored.tasks.any(
        (WorkspaceTask task) => task.title == 'Công việc kiểm thử',
      ),
      isTrue,
    );

    controller.dispose();
    restored.dispose();
  });
}
