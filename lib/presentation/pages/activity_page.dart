import 'package:flutter/material.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/presentation/widgets/page_header.dart';
import 'package:homework/state/workspace_controller.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final List<WorkspaceTask> tasks = controller.tasks.toList()
          ..sort(
            (WorkspaceTask left, WorkspaceTask right) =>
                right.createdAt.compareTo(left.createdAt),
          );
        return ListView(
          padding: const EdgeInsets.all(28),
          children: <Widget>[
            const PageHeader(
              title: 'Hoạt động',
              subtitle: 'Dòng thời gian thay đổi trong không gian HomeWork.',
            ),
            const SizedBox(height: 24),
            Card(
              child: tasks.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: Text('Chưa có hoạt động nào.')),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: <Widget>[
                          for (final WorkspaceTask task in tasks) ...<Widget>[
                            _ActivityItem(task: task),
                            if (task != tasks.last)
                              const Divider(
                                height: 1,
                                indent: 70,
                                endIndent: 18,
                              ),
                          ],
                        ],
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem({required this.task});

  final WorkspaceTask task;

  @override
  Widget build(BuildContext context) {
    final Color color = task.isCompleted
        ? const Color(0xFF16845B)
        : Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            foregroundColor: color,
            child: Icon(
              task.isCompleted ? Icons.done_rounded : Icons.add_task_rounded,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.isCompleted
                      ? 'Đã hoàn thành “${task.title}”'
                      : 'Đã tạo “${task.title}”',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  '${task.project}  •  ${_formatDateTime(task.createdAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String hour = date.hour.toString().padLeft(2, '0');
    final String minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/${date.year}, $hour:$minute';
  }
}
