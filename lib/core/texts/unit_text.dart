import 'package:flutter/material.dart';

class Text1 extends StatelessWidget {
  const Text1(this.data, {super.key});
  final String data;

  ///

  @override
  Widget build(BuildContext context) {
    return Text(data,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
  }
}
