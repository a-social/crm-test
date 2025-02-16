import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class NotesTimeline extends StatelessWidget {
  final User user;

  const NotesTimeline({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Notlar",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // ...user.notes.map((note) => _buildNoteItem(note)).toList(),
      ],
    );
  }

  // Widget _buildNoteItem(UserNote note) {
  //   return Column(
  //     children: [
  //       Row(
  //         children: [
  //           Text(note.date, style: const TextStyle(fontWeight: FontWeight.bold)),
  //           const SizedBox(width: 8),
  //           Text(note.content),
  //         ],
  //       ),
  //       const Divider(),
  //     ],
  //   );
  // }
}
