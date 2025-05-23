import 'package:flutter/material.dart';
import 'package:search_and_filter_dummy_data/screen/filter_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Search and filter',
      home: FilterScreen(),
    );
  }
}

