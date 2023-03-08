import 'package:flutter/material.dart';
import 'package:flutter_application/pages/login_screen/login_page.dart';
import 'package:flutter_application/pages/login_screen/welcome_page.dart';

/// Точка входа приложения

void main() => runApp(const MeRestaurantApp());

/// Основной управляющий класс
class MeRestaurantApp extends StatelessWidget {
  const MeRestaurantApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
