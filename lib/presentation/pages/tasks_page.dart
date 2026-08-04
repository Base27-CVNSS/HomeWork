import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/presentation/widgets/add_task_dialog.dart';
import 'package:homework/presentation/widgets/page_header.dart';
import 'package:homework/presentation/widgets/task_tile.dart';
import 'package:homework/state/workspace_controller.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final List<WorkspaceTask> tasks = controller.filteredTasks;
        return ListView(
          padding: const EdgeInsets.all(28),
          children: <Widget>[
            PageHeader(
              title: 'Công việc',
              subtitle: 'Lập kế hoạch, ưu tiên và hoàn thành từng việc một.',
              action: FilledButton.icon(
                onPressed: () => unawaited(
                  showAddTaskDialog(context, controller),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Công việc mới'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SegmentedButton<TaskFilter>(
                      segments: const <ButtonSegment<TaskFilter>>[
                        ButtonSegment<TaskFilter>(
                          value: TaskFilter.all,
                          label: Text('Tất cả'),
                          icon: Icon(Icons.list_alt_rounded),
                        ),
                        ButtonSegment<TaskFilter>(
                          value: TaskFilter.today,
                          label: Text('Hôm nay'),
                          icon: Icon(Icons.today_outlined),
                        ),
                        ButtonSegment<TaskFilter>(
                          value: TaskFilter.open,
                          label: Text('Đang làm'),
                          icon: Icon(Icons.pending_actions_outlined),
                        ),
                        ButtonSegment<TaskFilter>(
                          value: TaskFilter.completed,
                          label: Text('Hoàn thành'),
                          icon: Icon(Icons.done_all_rounded),
                        ),
                      ],
                      selected: <TaskFilter>{controller.filter},
                      onSelectionChanged: (Set<TaskFilter> selection) {
                        controller.setFilter(selection.first);
                      },
                    ),
                  ),
                ),
                if (controller.completedCount > 0) ...<Widget>[
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () => unawaited(controller.clearCompleted()),
                    icon: const Icon(Icons.cleaning_services_outlined),
                    label: const Text('Dọn việc đã xong'),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: tasks.isEmpty
                  ? const _EmptyTasks()
                  : Column(
                      children: <Widget>[
                        for (final WorkspaceTask task in tasks) ...<Widget>[
                          TaskTile(task: task, controller: controller),
                          if (task != tasks.last)
                            const Divider(
                              height: 1,
                              indent: 72,
                              endIndent: 16,
                            ),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyTasks extends StatelessWidget {
  const _EmptyTasks();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.inbox_outlined,
            size: 54,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 14),
          Text(
            'Chưa có công việc trong bộ lọc này',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          const Text('Hãy đổi bộ lọc hoặc tạo một công việc mới.'),
        ],
      ),
    );
  }
}
