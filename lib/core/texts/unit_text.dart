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

class Text2 extends StatelessWidget {
  ///20 bold black
  const Text2(this.data, {super.key});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
  }
}

class TextOfButton extends StatelessWidget {
  ///button
  const TextOfButton(this.data, {super.key});
  final String data;

  @override
  Widget build(BuildContext context) {
    return Text(data,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white));
  }
}
