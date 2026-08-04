import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/state/workspace_controller.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.controller,
    this.compact = false,
    super.key,
  });

  final WorkspaceTask task;
  final WorkspaceController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 6 : 9,
      ),
      child: Row(
        children: <Widget>[
          Checkbox(
            value: task.isCompleted,
            onChanged: (_) => unawaited(controller.toggleTask(task.id)),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  task.title,
                  maxLines: compact ? 1 : 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.isCompleted
                        ? colors.onSurfaceVariant
                        : colors.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: <Widget>[
                    _Meta(icon: Icons.folder_outlined, label: task.project),
                    if (task.dueDate != null)
                      _Meta(
                        icon: Icons.calendar_today_outlined,
                        label: _formatDate(task.dueDate!),
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          _PriorityBadge(priority: task.priority),
          if (!compact) ...<Widget>[
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'Xóa công việc',
              onPressed: () => unawaited(controller.deleteTask(task.id)),
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final DateTime now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Hôm nay';
    }
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}';
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  const _PriorityBadge({required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final (String label, Color color) = switch (priority) {
      TaskPriority.low => ('Thấp', const Color(0xFF16845B)),
      TaskPriority.normal => ('Vừa', const Color(0xFF4B65D6)),
      TaskPriority.high => ('Cao', const Color(0xFFD92D20)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
