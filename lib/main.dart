import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player/show_case_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarBrightness: Brightness.dark));

    return MaterialApp(
      home: ShowCasePage(),
    );
  }
}

class TestLateFinal extends StatefulWidget {
  @override
  _TestLateFinalState createState() => _TestLateFinalState();
}

class _TestLateFinalState extends State<TestLateFinal> {
  late final double e;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        setState(() {});
      },
      child: Container(
        color: Colors.red,
        child: Center(
          child: _TestLateFinal2State(),
        ),
      ),
    ));
  }
}

class _TestLateFinal2State extends StatelessWidget {
  late final A e;

  @override
  Widget build(BuildContext context) {
    String;
    e = A();
    print('hash ' + e.hashCode.toString());
    return Container(
      width: 500,
      height: 500,
      color: Colors.blue,
    );
  }
}

class A {
  A() {
    print('hehe');
  }
}
