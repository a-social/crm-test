import 'package:flutter/material.dart';
import 'package:crm_k/core/widgets/drawer/F/drawer_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicDrawer extends StatelessWidget {
  final Function(Widget) onMenuSelected;

  const DynamicDrawer({super.key, required this.onMenuSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: DrawerViewModel.menuItems.entries.map((entry) {
                String title = entry.key;
                var icon = entry.value.keys.first;
                Widget page = entry.value.values.first;

                return ListTile(
                  leading: icon,
                  title: Text(title),
                  onTap: () {
                    Navigator.pop(context); // Drawer'ı kapat
                    onMenuSelected(page); // Yeni sayfayı yükle
                  },
                );
              }).toList(),
            ),
          ),
          OpenLinkButton()
        ],
      ),
    );
  }
}

class OpenLinkButton extends StatelessWidget {
  const OpenLinkButton({super.key});

  void _launchURL() async {
    const url = 'https://google.com'; // Buraya istediğin linki koy
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Bağlantı açılamadı: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchURL,
      child: const Text('Linki Aç'),
    );
  }
}
