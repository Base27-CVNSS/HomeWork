import 'package:flutter/foundation.dart';
import 'package:homework/data/workspace_store.dart';
import 'package:homework/models/workspace_task.dart';

class WorkspaceController extends ChangeNotifier {
  WorkspaceController({required WorkspaceStore store}) : _store = store;

  static const List<String> projectNames = <String>[
    'Gia đình',
    'Cá nhân',
    'Công việc',
    'Học tập',
  ];

  final WorkspaceStore _store;
  final List<WorkspaceTask> _tasks = <WorkspaceTask>[];
  bool _darkMode = false;
  TaskFilter _filter = TaskFilter.all;

  List<WorkspaceTask> get tasks => List<WorkspaceTask>.unmodifiable(_tasks);
  bool get darkMode => _darkMode;
  TaskFilter get filter => _filter;

  List<WorkspaceTask> get filteredTasks {
    final DateTime now = DateTime.now();
    final List<WorkspaceTask> filtered = _tasks.where((WorkspaceTask task) {
      return switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.today =>
          task.dueDate != null && _sameDate(task.dueDate!, now),
        TaskFilter.open => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
      };
    }).toList();

    filtered.sort(_compareTasks);
    return filtered;
  }

  int get completedCount =>
      _tasks.where((WorkspaceTask task) => task.isCompleted).length;

  int get openCount => _tasks.length - completedCount;

  int get dueTodayCount {
    final DateTime now = DateTime.now();
    return _tasks
        .where(
          (WorkspaceTask task) =>
              !task.isCompleted &&
              task.dueDate != null &&
              _sameDate(task.dueDate!, now),
        )
        .length;
  }

  Future<void> load() async {
    final Map<String, Object?>? data = await _store.read();
    _tasks.clear();

    final Object? rawTasks = data?['tasks'];
    if (rawTasks is List<Object?>) {
      for (final Object? item in rawTasks) {
        if (item is Map<String, Object?>) {
          try {
            _tasks.add(WorkspaceTask.fromJson(item));
          } on FormatException {
            // Ignore one malformed task without discarding the whole workspace.
          } on TypeError {
            // Ignore one malformed task without discarding the whole workspace.
          }
        }
      }
    }

    _darkMode = data?['darkMode'] as bool? ?? false;
    if (data == null) {
      _tasks.addAll(_starterTasks());
      await _save();
    }
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    if (_filter == filter) {
      return;
    }
    _filter = filter;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required String project,
    required TaskPriority priority,
    DateTime? dueDate,
  }) async {
    final String normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      return;
    }

    final DateTime now = DateTime.now();
    _tasks.add(
      WorkspaceTask(
        id: now.microsecondsSinceEpoch.toString(),
        title: normalizedTitle,
        project: project,
        createdAt: now,
        dueDate: dueDate,
        priority: priority,
      ),
    );
    notifyListeners();
    await _save();
  }

  Future<void> toggleTask(String id) async {
    final int index = _tasks.indexWhere(
      (WorkspaceTask task) => task.id == id,
    );
    if (index < 0) {
      return;
    }
    _tasks[index] = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );
    notifyListeners();
    await _save();
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((WorkspaceTask task) => task.id == id);
    notifyListeners();
    await _save();
  }

  Future<void> clearCompleted() async {
    _tasks.removeWhere((WorkspaceTask task) => task.isCompleted);
    notifyListeners();
    await _save();
  }

  Future<void> setDarkMode({required bool enabled}) async {
    _darkMode = enabled;
    notifyListeners();
    await _save();
  }

  double projectProgress(String project) {
    final List<WorkspaceTask> projectTasks = _tasks
        .where((WorkspaceTask task) => task.project == project)
        .toList();
    if (projectTasks.isEmpty) {
      return 0;
    }
    final int done = projectTasks
        .where((WorkspaceTask task) => task.isCompleted)
        .length;
    return done / projectTasks.length;
  }

  int projectTaskCount(String project) {
    return _tasks.where((WorkspaceTask task) => task.project == project).length;
  }

  Future<void> _save() {
    return _store.write(<String, Object?>{
      'schemaVersion': 1,
      'darkMode': _darkMode,
      'tasks': _tasks
          .map((WorkspaceTask task) => task.toJson())
          .toList(growable: false),
    });
  }

  int _compareTasks(WorkspaceTask left, WorkspaceTask right) {
    if (left.isCompleted != right.isCompleted) {
      return left.isCompleted ? 1 : -1;
    }
    if (left.dueDate == null && right.dueDate == null) {
      return right.createdAt.compareTo(left.createdAt);
    }
    if (left.dueDate == null) {
      return 1;
    }
    if (right.dueDate == null) {
      return -1;
    }
    return left.dueDate!.compareTo(right.dueDate!);
  }

  bool _sameDate(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  List<WorkspaceTask> _starterTasks() {
    final DateTime now = DateTime.now();
    return <WorkspaceTask>[
      WorkspaceTask(
        id: 'starter-1',
        title: 'Lập kế hoạch cho tuần mới',
        project: 'Công việc',
        createdAt: now,
        dueDate: now,
        priority: TaskPriority.high,
      ),
      WorkspaceTask(
        id: 'starter-2',
        title: 'Hoàn thành 30 phút đọc sách',
        project: 'Cá nhân',
        createdAt: now.subtract(const Duration(hours: 2)),
        dueDate: now,
        priority: TaskPriority.normal,
      ),
      WorkspaceTask(
        id: 'starter-3',
        title: 'Chuẩn bị danh sách mua sắm',
        project: 'Gia đình',
        createdAt: now.subtract(const Duration(days: 1)),
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.normal,
      ),
      WorkspaceTask(
        id: 'starter-4',
        title: 'Ôn lại ghi chú khóa học',
        project: 'Học tập',
        createdAt: now.subtract(const Duration(days: 2)),
        dueDate: now.add(const Duration(days: 2)),
        priority: TaskPriority.low,
        isCompleted: true,
      ),
    ];
  }
}
