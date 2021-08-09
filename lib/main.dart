import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_demo/scroll_provider.dart';
import 'package:scroll_demo/scroll_view.dart';

void main() {
  runApp(
    ChangeNotifierProvider<ScrollProvider>(
      create: (_) => ScrollProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Scroll Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScrollViewContent(),
    );
  }
}
