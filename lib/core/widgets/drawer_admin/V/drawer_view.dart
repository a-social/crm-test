import 'package:crm_k/core/widgets/drawer_admin/F/drawer_viewmodel.dart';
import 'package:flutter/material.dart';

class DynamicDrawerAdmin extends StatefulWidget {
  final Function(Widget) onMenuSelected;

  const DynamicDrawerAdmin({super.key, required this.onMenuSelected});

  @override
  _DynamicDrawerAdminState createState() => _DynamicDrawerAdminState();
}

class _DynamicDrawerAdminState extends State<DynamicDrawerAdmin> {
  String? expandedMenu; // Hangi menü açık, tutuluyor

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Center(
                child: Text("Admin Paneli",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          ),
          Expanded(
            child: ListView(
              children: DynamicDrawerVMAdmin.menuItems.map((menuItem) {
                bool hasSubmenu = menuItem.containsKey("submenu");

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(menuItem["icon"]),
                      title: Text(menuItem["title"]),
                      trailing: hasSubmenu
                          ? Icon(expandedMenu == menuItem["title"]
                              ? Icons.expand_less
                              : Icons.expand_more)
                          : null,
                      onTap: () {
                        if (hasSubmenu) {
                          setState(() {
                            expandedMenu = expandedMenu == menuItem["title"]
                                ? null
                                : menuItem["title"];
                          });
                        } else {
                          Navigator.pop(context);
                          widget.onMenuSelected(menuItem["page"]);
                        }
                      },
                    ),
                    // **Alt Menüleri Açılan Hale Getir**
                    if (hasSubmenu && expandedMenu == menuItem["title"])
                      Column(
                        children:
                            (menuItem["submenu"] as List<Map<String, dynamic>>)
                                .map((submenuItem) {
                          return ListTile(
                            leading: Icon(submenuItem["icon"], size: 20),
                            title: Text(submenuItem["title"],
                                style: const TextStyle(fontSize: 14)),
                            onTap: () {
                              Navigator.pop(context);
                              widget.onMenuSelected(submenuItem["page"]);
                            },
                          );
                        }).toList(),
                      ),
                    const Divider()
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
