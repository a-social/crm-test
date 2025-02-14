import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view.dart';

import 'package:flutter/material.dart';

class DeleteUser extends StatelessWidget {
  const DeleteUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
            flex: 2,
            child: Container(
              child: UserListScreenView(),
            )),
        Expanded(child: Container()),
        Expanded(
            child: Container(
          child: RightPanelUserView(isDelete: true),
        )),
      ],
    );
  }
}
