import 'package:crm_k/core/models/user_model/user_mode.dart';
import 'package:flutter/material.dart';

class TagManager extends StatelessWidget {
  final User user;

  const TagManager({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(user.phoneStatus ?? 'Etiketi Yok'),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Tag Ekle"),
        ),
      ],
    );
  }
}
