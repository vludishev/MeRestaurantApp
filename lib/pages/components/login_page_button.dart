import 'package:flutter/material.dart';

class LoginPageButton extends StatelessWidget {
  final Function()? onTap;

  const LoginPageButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          //  inputDecoration: InputDecoration(
          //     enabledBorder: const UnderlineInputBorder(
          //       borderSide: BorderSide(color: Colors.white),
          //     ),
          //     focusedBorder: UnderlineInputBorder(
          //       borderSide: BorderSide(color: Colors.grey.shade400),
          //     ),
          //     hintText: hintText,
          //     hintStyle: const TextStyle(color: Colors.white),
          //   ),

          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          // border: Border.all(color: Colors.white),
        ),
        child: const Center(
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
