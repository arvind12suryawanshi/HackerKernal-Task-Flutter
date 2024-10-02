import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'add_product_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/addProduct': (context) => AddProductPage(),
      },
    );
  }
}
