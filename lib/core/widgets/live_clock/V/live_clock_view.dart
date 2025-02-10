import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Tarih formatı için

class LiveClock extends StatefulWidget {
  const LiveClock({super.key});

  ///
  ///databaseden yerel saat çekmemiz gerek bilgisayar saati ile olmaz

  @override
  _LiveClockState createState() => _LiveClockState();
}

class _LiveClockState extends State<LiveClock> {
  late Stream<String> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream = Stream.periodic(Duration(seconds: 1), (_) {
      return DateFormat("HH:mm:ss")
          .format(DateTime.now()); // Saat formatı: 17:55:32
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: _timeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Text("Yükleniyor...", style: TextStyle());
        return Text(snapshot.data!,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
      },
    );
  }
}
