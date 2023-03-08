import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application/pages/components/custom_page_route.dart';
import 'package:flutter_application/pages/components/login_page_button.dart';
import 'package:flutter_application/pages/login_screen/login_page.dart';

import '../components/login_page_textfield.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final TextEditingController phoneNumber = TextEditingController();
  bool selected = false;
  GlobalKey containerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final keyContext = containerKey.currentContext;
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      return Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selected = !selected;
              });
            },
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/login_screen.jpg'),
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Welcome To',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ButterflyWingsDemoRegular'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'My Restaurant',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ButterflyWingsDemoRegular'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Make your life convenient',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 30,
                            fontFamily: 'ButterflyWingsDemoRegular'),
                      ),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        height: selected ? box.size.height + 190 : 2.0,
                        duration: const Duration(seconds: 2),
                        curve: Curves.fastOutSlowIn,
                        child: LoginPageTextField(
                          widgetKey: containerKey,
                          controller: phoneNumber,
                          hintText: 'Phone',
                        ),
                      ),
                      // LoginPageTextField(
                      //     controller: phoneNumber, hintText: 'Number'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Container();
  }
}
