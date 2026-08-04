import 'dart:convert';
import 'dart:io';

class WorkspaceStore {
  WorkspaceStore({Directory? directory}) : _directory = directory;

  final Directory? _directory;

  Future<Map<String, Object?>?> read() async {
    final File file = await _workspaceFile();
    if (!await file.exists()) {
      return null;
    }

    try {
      final Object? decoded = jsonDecode(await file.readAsString());
      if (decoded is Map<String, Object?>) {
        return decoded;
      }
    } on FormatException {
      await _backupInvalidFile(file);
    }
    return null;
  }

  Future<void> write(Map<String, Object?> data) async {
    final File file = await _workspaceFile();
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(data), flush: true);
  }

  Future<File> _workspaceFile() async {
    final Directory directory = _directory ?? _defaultDirectory();
    await directory.create(recursive: true);
    return File('${directory.path}${Platform.pathSeparator}workspace.json');
  }

  Directory _defaultDirectory() {
    final String basePath =
        Platform.environment['APPDATA'] ??
        Platform.environment['USERPROFILE'] ??
        Directory.current.path;
    return Directory('$basePath${Platform.pathSeparator}HomeWork');
  }

  Future<void> _backupInvalidFile(File file) async {
    final String stamp = DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await file.rename('${file.path}.invalid-$stamp');
    } on FileSystemException {
      // The application can still recover with a fresh workspace if backup fails.
    }
  }
}
