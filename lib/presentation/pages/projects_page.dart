import 'package:flutter/material.dart';
import 'package:homework/presentation/widgets/page_header.dart';
import 'package:homework/state/workspace_controller.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({required this.controller, super.key});

  final WorkspaceController controller;

  static const List<Color> _colors = <Color>[
    Color(0xFF1459D9),
    Color(0xFF7A5AF8),
    Color(0xFFD92D20),
    Color(0xFF16845B),
  ];

  static const List<IconData> _icons = <IconData>[
    Icons.home_rounded,
    Icons.self_improvement_rounded,
    Icons.work_rounded,
    Icons.school_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return ListView(
          padding: const EdgeInsets.all(28),
          children: <Widget>[
            const PageHeader(
              title: 'Dự án',
              subtitle: 'Nhìn rõ tiến độ của từng khu vực trong cuộc sống.',
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final int columns = constraints.maxWidth >= 900 ? 2 : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 205,
                  ),
                  itemCount: WorkspaceController.projectNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String project =
                        WorkspaceController.projectNames[index];
                    return _ProjectCard(
                      name: project,
                      taskCount: controller.projectTaskCount(project),
                      progress: controller.projectProgress(project),
                      color: _colors[index],
                      icon: _icons[index],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.name,
    required this.taskCount,
    required this.progress,
    required this.color,
    required this.icon,
  });

  final String name;
  final int taskCount;
  final double progress;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('$taskCount công việc'),
                    ],
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const Spacer(),
            LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 10),
            Text(
              taskCount == 0
                  ? 'Sẵn sàng cho công việc đầu tiên'
                  : '${(progress * taskCount).round()} trên $taskCount việc đã xong',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
