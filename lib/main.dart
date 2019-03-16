import "package:flutter/material.dart";

import "search.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: HomePage()
    );

  }

}