import 'package:crm_k/core/widgets/fast_links/VM/fast_link_viewmodel.dart';
import 'package:flutter/material.dart';

class FastLinkView extends StatefulWidget {
  const FastLinkView({super.key});

  @override
  State<FastLinkView> createState() => _FastLinkViewState();
}

class _FastLinkViewState extends State<FastLinkView> {
  final ScrollController _scrollController =
      ScrollController(); // 📌 ScrollController tanımla
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      thumbVisibility: true,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        physics: ClampingScrollPhysics(),
        children: FastLinkMenuITems.menuItems.entries.map((entry) {
          String title = entry.key;
          Icon icon = entry.value.keys.first;
          Widget page = entry.value.values.first;

          return ListTile(
            dense: true,
            leading: icon,
            title: Text(title),
            onTap: () {
              FastLinkMenuITems.showAddUserDialog(context, page);
            },
          );
        }).toList(),
      ),
    );
  }
}
