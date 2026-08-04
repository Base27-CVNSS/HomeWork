import 'dart:async';

import 'package:flutter/material.dart';
import 'package:homework/presentation/widgets/page_header.dart';
import 'package:homework/state/workspace_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({required this.controller, super.key});

  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return ListView(
          padding: const EdgeInsets.all(28),
          children: <Widget>[
            const PageHeader(
              title: 'Cài đặt',
              subtitle: 'Tùy chỉnh HomeWork theo cách bạn muốn làm việc.',
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: controller.darkMode,
                    onChanged: (bool enabled) => unawaited(
                      controller.setDarkMode(enabled: enabled),
                    ),
                    secondary: const Icon(Icons.dark_mode_outlined),
                    title: const Text('Giao diện tối'),
                    subtitle: const Text(
                      'Giảm độ sáng khi làm việc trong môi trường thiếu sáng.',
                    ),
                  ),
                  const Divider(height: 1, indent: 72),
                  const ListTile(
                    leading: Icon(Icons.cloud_off_outlined),
                    title: Text('Làm việc ngoại tuyến'),
                    subtitle: Text(
                      'Dữ liệu chỉ lưu trên máy, không cần tài khoản hay máy chủ.',
                    ),
                    trailing: Chip(label: Text('Đang bật')),
                  ),
                  const Divider(height: 1, indent: 72),
                  const ListTile(
                    leading: Icon(Icons.folder_copy_outlined),
                    title: Text('Vị trí dữ liệu'),
                    subtitle: Text(r'%APPDATA%\HomeWork\workspace.json'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/branding/homework-icon.png',
                      width: 76,
                      height: 76,
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'HomeWork',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          const Text('Phiên bản 1.0.0 • Windows desktop'),
                          const SizedBox(height: 6),
                          const Text(
                            'Không gian làm việc cá nhân sạch, nhanh và riêng tư.',
                          ),
                        ],
                      ),
                    ),
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
