import 'package:crm_k/screens/admin/dashboard/V/middle/V/middle_view.dart';
import 'package:flutter/material.dart';

class PersonelUpdateView extends StatelessWidget {
  const PersonelUpdateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersonelScreenViewState(
        isUpdate: true,
      ),
    );
  }
}
