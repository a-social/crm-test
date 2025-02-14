import 'package:flutter/material.dart';

class AddBasicModel extends StatelessWidget {
  const AddBasicModel({super.key, required this.widget});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.sizeOf(context).height / 2,
          width: MediaQuery.sizeOf(context).width / 3,
          child: widget,
        ),
      ),
    ));
  }
}
