import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/presentation/widgets/add_task_dialog.dart';
import 'package:homework/presentation/widgets/page_header.dart';
import 'package:homework/presentation/widgets/task_tile.dart';
import 'package:homework/state/workspace_controller.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return ListView(
          padding: const EdgeInsets.all(28),
          children: <Widget>[
            PageHeader(
              title: _greeting(),
              subtitle: 'Tập trung vào những việc quan trọng nhất hôm nay.',
              action: FilledButton.icon(
                onPressed: () => unawaited(
                  showAddTaskDialog(context, controller),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Thêm công việc'),
              ),
            ),
            const SizedBox(height: 26),
            _Stats(controller: controller),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth >= 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: _FocusTasks(controller: controller),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        flex: 3,
                        child: _ProjectProgress(controller: controller),
                      ),
                    ],
                  );
                }
                return Column(
                  children: <Widget>[
                    _FocusTasks(controller: controller),
                    const SizedBox(height: 18),
                    _ProjectProgress(controller: controller),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  String _greeting() {
    final int hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Chào buổi sáng!';
    }
    if (hour < 18) {
      return 'Chào buổi chiều!';
    }
    return 'Chào buổi tối!';
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.controller});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final List<_StatData> items = <_StatData>[
      _StatData(
        label: 'Tất cả công việc',
        value: controller.tasks.length.toString(),
        icon: Icons.task_alt_rounded,
        color: const Color(0xFF1459D9),
      ),
      _StatData(
        label: 'Cần hoàn thành',
        value: controller.openCount.toString(),
        icon: Icons.pending_actions_rounded,
        color: const Color(0xFFF79009),
      ),
      _StatData(
        label: 'Đến hạn hôm nay',
        value: controller.dueTodayCount.toString(),
        icon: Icons.today_rounded,
        color: const Color(0xFFD92D20),
      ),
      _StatData(
        label: 'Đã hoàn thành',
        value: controller.completedCount.toString(),
        icon: Icons.verified_rounded,
        color: const Color(0xFF16845B),
      ),
    ];

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth >= 980 ? 4 : 2;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 124,
          ),
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return _StatCard(data: items[index]);
          },
        );
      },
    );
  }
}

class _StatData {
  const _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    data.value,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    data.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusTasks extends StatelessWidget {
  const _FocusTasks({required this.controller});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final List<WorkspaceTask> tasks = controller.tasks
        .where((WorkspaceTask task) => !task.isCompleted)
        .take(5)
        .toList(growable: false);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Text(
                'Ưu tiên hôm nay',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (tasks.isEmpty)
              const _EmptyFocus()
            else
              for (final WorkspaceTask task in tasks) ...<Widget>[
                TaskTile(task: task, controller: controller, compact: true),
                if (task != tasks.last)
                  const Divider(height: 1, indent: 64, endIndent: 18),
              ],
          ],
        ),
      ),
    );
  }
}

class _EmptyFocus extends StatelessWidget {
  const _EmptyFocus();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: <Widget>[
            Icon(
              Icons.celebration_outlined,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 10),
            const Text('Tuyệt vời — bạn đã hoàn thành mọi việc!'),
          ],
        ),
      ),
    );
  }
}

class _ProjectProgress extends StatelessWidget {
  const _ProjectProgress({required this.controller});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Tiến độ dự án',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            for (final String project in WorkspaceController.projectNames) ...<
              Widget
            >[
              Row(
                children: <Widget>[
                  Expanded(child: Text(project)),
                  Text(
                    '${(controller.projectProgress(project) * 100).round()}%',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              const SizedBox(height: 7),
              LinearProgressIndicator(
                value: controller.projectProgress(project),
                minHeight: 7,
                borderRadius: BorderRadius.circular(99),
                backgroundColor: colors.surfaceContainerHighest,
              ),
              const SizedBox(height: 17),
            ],
          ],
        ),
      ),
    );
  }
}
