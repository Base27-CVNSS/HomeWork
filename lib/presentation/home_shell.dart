import 'package:flutter/material.dart';
import 'package:homework/presentation/pages/activity_page.dart';
import 'package:homework/presentation/pages/dashboard_page.dart';
import 'package:homework/presentation/pages/projects_page.dart';
import 'package:homework/presentation/pages/settings_page.dart';
import 'package:homework/presentation/pages/tasks_page.dart';
import 'package:homework/state/workspace_controller.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool extended = constraints.maxWidth >= 1120;
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: <Widget>[
                NavigationRail(
                  extended: extended,
                  minExtendedWidth: 238,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int value) {
                    setState(() => _selectedIndex = value);
                  },
                  leading: _Brand(extended: extended),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: _VersionLabel(extended: extended),
                      ),
                    ),
                  ),
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(Icons.space_dashboard_outlined),
                      selectedIcon: Icon(Icons.space_dashboard_rounded),
                      label: Text('Tổng quan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      selectedIcon: Icon(Icons.check_circle_rounded),
                      label: Text('Công việc'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.folder_outlined),
                      selectedIcon: Icon(Icons.folder_rounded),
                      label: Text('Dự án'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.history_rounded),
                      selectedIcon: Icon(Icons.history_toggle_off_rounded),
                      label: Text('Hoạt động'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings_rounded),
                      label: Text('Cài đặt'),
                    ),
                  ],
                ),
                VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: <Widget>[
                      DashboardPage(controller: widget.controller),
                      TasksPage(controller: widget.controller),
                      ProjectsPage(controller: widget.controller),
                      ActivityPage(controller: widget.controller),
                      SettingsPage(controller: widget.controller),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 28),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset(
            'assets/branding/homework-icon.png',
            width: 48,
            height: 48,
          ),
          if (extended) ...<Widget>[
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'HomeWork',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Không gian của bạn',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _VersionLabel extends StatelessWidget {
  const _VersionLabel({required this.extended});

  final bool extended;

  @override
  Widget build(BuildContext context) {
    if (!extended) {
      return const Tooltip(message: 'HomeWork v1.0.0', child: Icon(Icons.home));
    }
    return Text(
      'HomeWork  •  v1.0.0',
      style: Theme.of(context).textTheme.labelSmall,
    );
  }
}
