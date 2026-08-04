enum TaskPriority { low, normal, high }

enum TaskFilter { all, today, open, completed }

class WorkspaceTask {
  const WorkspaceTask({
    required this.id,
    required this.title,
    required this.project,
    required this.createdAt,
    required this.priority,
    this.dueDate,
    this.isCompleted = false,
  });

  factory WorkspaceTask.fromJson(Map<String, Object?> json) {
    return WorkspaceTask(
      id: json['id'] as String,
      title: json['title'] as String,
      project: json['project'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      priority: TaskPriority.values.firstWhere(
        (TaskPriority item) => item.name == json['priority'],
        orElse: () => TaskPriority.normal,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String project;
  final DateTime createdAt;
  final DateTime? dueDate;
  final TaskPriority priority;
  final bool isCompleted;

  WorkspaceTask copyWith({
    String? title,
    String? project,
    DateTime? dueDate,
    TaskPriority? priority,
    bool? isCompleted,
  }) {
    return WorkspaceTask(
      id: id,
      title: title ?? this.title,
      project: project ?? this.project,
      createdAt: createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'title': title,
      'project': project,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'priority': priority.name,
      'isCompleted': isCompleted,
    };
  }
}
