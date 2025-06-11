import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'provider/home_provider.dart';
import 'view/homepage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => PostProvider(),
      child: MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Post App',
      home: HomePage(),
    );
  }
}
