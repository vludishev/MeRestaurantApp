import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'login_page_button.dart';

class LoginPageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final GlobalKey widgetKey;

  LoginPageTextField({
    super.key,
    required this.widgetKey,
    required this.controller,
    required this.hintText,
  });

  PhoneNumber number = PhoneNumber(isoCode: 'GE');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        key: widgetKey,
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
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  print(number.phoneNumber);
                },
                onInputValidated: (bool value) {
                  print(value);
                },
                selectorConfig: const SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: const TextStyle(
                  color: Colors.white,
                ),
                initialValue: number,
                textFieldController: controller,
                formatInput: true,
                inputDecoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.white),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                    signed: true, decimal: true),
                inputBorder: const OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  print('On Saved: $number');
                },
              ),
              const SizedBox(height: 20),
              LoginPageButton(
                onTap: () => {print('Click')},
              ),
            ],
          ),
        ),
      ),
    );
    // TextField(
    //   controller: controller,
    //   obscureText: obscureText,
    //   decoration: InputDecoration(
    //       enabledBorder: const UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.white),
    //       ),
    //       focusedBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.grey.shade400),
    //       ),
    //       // fillColor: Colors.grey.shade200,
    //       // filled: true,
    //       hintText: hintText,
    //       hintStyle: TextStyle(color: Colors.grey[500])),
    // ),
  }
}
