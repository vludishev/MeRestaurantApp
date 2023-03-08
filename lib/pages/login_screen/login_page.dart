import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application/pages/components/login_page_button.dart';
import 'package:flutter_application/pages/components/login_page_textfield.dart';
import 'package:flutter_application/pages/components/square_tile.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repPasswordController = TextEditingController();

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/login_screen1.jpg'),
                  fit: BoxFit.cover)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
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
                  const SizedBox(height: 60),

                  const SizedBox(height: 10),

                  // // Повторение пароль
                  // LoginPageTextField(
                  //   controller: repPasswordController,
                  //   hintText: 'Повторите пароль',
                  //   obscureText: true,
                  // ),

                  // const SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  LoginPageButton(onTap: signUserIn),

                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      SquareTile(imagePath: 'lib/icons/google.png'),
                      SizedBox(width: 25),
                      SquareTile(imagePath: 'lib/icons/vk.png'),
                    ],
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Not a member',
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
