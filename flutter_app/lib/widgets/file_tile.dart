import 'package:flutter/material.dart';

import '../models/file_item.dart';

class FileTile extends StatelessWidget {
  const FileTile({super.key, required this.file, required this.onRemove});

  final FileItem file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool busy = file.status == FileUploadStatus.uploading ||
        file.status == FileUploadStatus.processing;

    final Widget status;
    switch (file.status) {
      case FileUploadStatus.queued:
        status = const Icon(Icons.schedule, color: Colors.grey);
      case FileUploadStatus.uploading:
      case FileUploadStatus.processing:
        status = const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case FileUploadStatus.processed:
        status = const Icon(Icons.check_circle, color: Colors.green);
      case FileUploadStatus.failed:
        status = const Icon(Icons.error, color: Colors.red);
    }

    final String statusText = switch (file.status) {
      FileUploadStatus.queued => 'Queued',
      FileUploadStatus.uploading => 'Uploading…',
      FileUploadStatus.processing => 'Processing…',
      FileUploadStatus.processed => 'Processed',
      FileUploadStatus.failed => 'Failed',
    };

    return ListTile(
      leading: const Icon(Icons.insert_drive_file),
      title: Text(
        file.name,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            statusText,
            style: theme.textTheme.labelSmall?.copyWith(
              color: file.status == FileUploadStatus.failed
                  ? theme.colorScheme.error
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (file.status == FileUploadStatus.failed &&
              file.errorMessage != null)
            Text(
              file.errorMessage!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          status,
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: busy ? null : onRemove,
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
