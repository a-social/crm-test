import 'package:crm_k/core/widgets/drawer/V/drawer_view.dart';
import 'package:crm_k/screens/home_screen/V/home2.dart';
import 'package:flutter/material.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DynamicDrawer(
        onMenuSelected: (Widget newPage) {},
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserListScreen(),
                ));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class veri {
  void checkUpdate() {
    print('yazdır');
  }
}
