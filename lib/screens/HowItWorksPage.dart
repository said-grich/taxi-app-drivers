import 'package:flutter/material.dart';

class HowItWorkPage extends StatefulWidget {

  static String id = "HowItWorkPage";

  @override
  _HowItWorkPageState createState() => _HowItWorkPageState();
}

class _HowItWorkPageState extends State<HowItWorkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "How it Work Page"
        ),
      ),
    );
  }
}
