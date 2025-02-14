import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:crm_k/screens/admin/dashboard/V/right_panel/V/right_panel_view_for_personel.dart';

import 'package:flutter/material.dart';

class DeletePerson extends StatelessWidget {
  const DeletePerson({super.key});

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
          child: RightPanelPersonnelView(isDelete: true),
        )),
      ],
    );
  }
}
