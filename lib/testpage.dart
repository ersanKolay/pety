import 'package:flutter/material.dart';
import './localization/constant_localizations.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text(getTranslated(context, 'username'))),
    );
  }
}
