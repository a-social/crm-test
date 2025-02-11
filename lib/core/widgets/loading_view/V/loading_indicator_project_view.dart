import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.loading_value});
  final bool loading_value;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: loading_value,
      child: Container(
        color: Colors.black,
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
