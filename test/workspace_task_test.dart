import 'package:flutter_test/flutter_test.dart';
import 'package:homework/models/workspace_task.dart';

void main() {
  test('WorkspaceTask round-trips through JSON', () {
    final WorkspaceTask source = WorkspaceTask(
      id: 'task-1',
      title: 'Kiểm tra dữ liệu',
      project: 'Công việc',
      createdAt: DateTime.utc(2026, 8, 4, 8),
      dueDate: DateTime.utc(2026, 8, 5),
      priority: TaskPriority.high,
      isCompleted: true,
    );

    final WorkspaceTask restored = WorkspaceTask.fromJson(source.toJson());

    expect(restored.id, source.id);
    expect(restored.title, source.title);
    expect(restored.dueDate, source.dueDate);
    expect(restored.priority, TaskPriority.high);
    expect(restored.isCompleted, isTrue);
  });
}
