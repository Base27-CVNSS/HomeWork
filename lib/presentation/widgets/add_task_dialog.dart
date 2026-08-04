import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homework/models/workspace_task.dart';
import 'package:homework/state/workspace_controller.dart';

Future<void> showAddTaskDialog(
  BuildContext context,
  WorkspaceController controller,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) => AddTaskDialog(controller: controller),
  );
}

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String _project = WorkspaceController.projectNames.first;
  TaskPriority _priority = TaskPriority.normal;
  DateTime? _dueDate = DateTime.now();
  bool _saving = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tạo công việc mới'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                autofocus: true,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Tên công việc',
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
                validator: (String? value) {
                  return value == null || value.trim().isEmpty
                      ? 'Hãy nhập tên công việc.'
                      : null;
                },
                onFieldSubmitted: (_) => unawaited(_submit()),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _project,
                      decoration: const InputDecoration(
                        labelText: 'Dự án',
                        prefixIcon: Icon(Icons.folder_outlined),
                      ),
                      items: WorkspaceController.projectNames
                          .map(
                            (String project) => DropdownMenuItem<String>(
                              value: project,
                              child: Text(project),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (String? value) {
                        if (value != null) {
                          setState(() => _project = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<TaskPriority>(
                      initialValue: _priority,
                      decoration: const InputDecoration(
                        labelText: 'Ưu tiên',
                        prefixIcon: Icon(Icons.flag_outlined),
                      ),
                      items: const <DropdownMenuItem<TaskPriority>>[
                        DropdownMenuItem<TaskPriority>(
                          value: TaskPriority.low,
                          child: Text('Thấp'),
                        ),
                        DropdownMenuItem<TaskPriority>(
                          value: TaskPriority.normal,
                          child: Text('Bình thường'),
                        ),
                        DropdownMenuItem<TaskPriority>(
                          value: TaskPriority.high,
                          child: Text('Cao'),
                        ),
                      ],
                      onChanged: (TaskPriority? value) {
                        if (value != null) {
                          setState(() => _priority = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Hạn hoàn thành',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _dueDate == null ? 'Không đặt hạn' : _formatDate(_dueDate!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _submit,
          icon: _saving
              ? const SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_rounded),
          label: const Text('Thêm công việc'),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
      helpText: 'CHỌN HẠN HOÀN THÀNH',
      cancelText: 'HỦY',
      confirmText: 'CHỌN',
    );
    if (selected != null && mounted) {
      setState(() => _dueDate = selected);
    }
  }

  Future<void> _submit() async {
    if (_saving || !(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);
    await widget.controller.addTask(
      title: _titleController.text,
      project: _project,
      priority: _priority,
      dueDate: _dueDate,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
