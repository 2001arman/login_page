import 'package:flutter/material.dart';
import 'package:login_page/Screens/Login/components/text_field_container.dart';
import 'package:login_page/components/providerPassword.dart';
import 'package:login_page/constants.dart';
import 'package:provider/provider.dart';

bool _lihatPassword = true;

class RoundedPasswordField extends StatefulWidget {
  final TextEditingController controller;
  const RoundedPasswordField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        controller: widget.controller,
        obscureText: _lihatPassword,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(Icons.lock, color: kPrimaryColor),
          suffixIcon: IconButton(
            icon: _lihatPassword
                ? Icon(Icons.visibility, color: kPrimaryColor)
                : Icon(Icons.visibility_off, color: kPrimaryColor),
            onPressed: () {
              if (_lihatPassword == true) {
                setState(() {
                  _lihatPassword = false;
                });
              } else if (_lihatPassword == false) {
                setState(() {
                  _lihatPassword = true;
                });
              }
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
