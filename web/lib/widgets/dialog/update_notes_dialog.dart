import 'package:flutter/material.dart';

class UpdateNotesDialog extends StatelessWidget {
  final List<String> notes;

  const UpdateNotesDialog({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('업데이트 안내'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: notes.map((note) => Text('• $note')).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('확인'),
        ),
      ],
    );
  }
}