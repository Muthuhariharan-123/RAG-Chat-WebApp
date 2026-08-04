import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../change_notifiers/upload_store.dart';
import '../models/file_item.dart';
import '../widgets/file_tile.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key, required this.store});

  final UploadStore store;

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _mockFail = false;

  Future<void> _pickFiles() async {
    final store = widget.store;
    if (store.isFull) {
      _showError('Maximum ${UploadStore.maxFiles} files allowed for this '
          'session.');
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf'],
      allowMultiple: true,
    );
    if (result == null) {
      return;
    }

    final remaining = UploadStore.maxFiles - store.files.length;
    final newFiles = <FileItem>[];
    final rejected = <String>[];

    for (final picked in result.files) {
      if (newFiles.length >= remaining) {
        rejected.add(picked.name);
        continue;
      }
      final ext = (picked.extension ?? '').toLowerCase();
      final bytes = picked.bytes;
      if (!UploadStore.allowedExtensions.contains(ext) || bytes == null) {
        rejected.add(picked.name);
        continue;
      }
      newFiles.add(FileItem(name: picked.name, bytes: bytes));
    }

    if (rejected.isNotEmpty) {
      final reason = store.isFull
          ? 'session limit reached (max ${UploadStore.maxFiles})'
          : 'unsupported type or empty file';
      _showError('Skipped ${rejected.length} file(s): $reason.');
    }
    if (newFiles.isNotEmpty) {
      store.addFiles(newFiles);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: widget.store,
      builder: (context, _) {
        final store = widget.store;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: store.isBusy ? null : _pickFiles,
                      icon: const Icon(Icons.add),
                      label: const Text('Add files (.txt / .pdf, max 10)'),
                    ),
                  ),
                  if (store.hasFiles) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete_sweep),
                      tooltip: 'Clear all',
                      onPressed: store.isBusy ? null : store.clear,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: store.files.isEmpty
                    ? _EmptyState(theme: theme)
                    : ListView.separated(
                        itemCount: store.files.length,
                        separatorBuilder: (_, _) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final file = store.files[index];
                          return FileTile(
                            file: file,
                            onRemove: () => store.removeFile(file),
                          );
                        },
                      ),
              ),
              if (store.supportsMockFailureToggle) ...[
                const Divider(),
                SwitchListTile(
                  title: const Text('Simulate upload failure (mock)'),
                  subtitle: const Text('Debug toggle to exercise the error UI'),
                  value: _mockFail,
                  onChanged: (value) {
                    setState(() => _mockFail = value);
                    store.setMockForceFail(value);
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 12),
          Text(
            'No files uploaded yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Add up to 10 .txt or .pdf files.\nThey will be processed '
            'automatically.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
