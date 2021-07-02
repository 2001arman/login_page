import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/Screens/Login/components/already_have_an_account_check.dart';
import 'package:login_page/Screens/Login/components/background.dart';
import 'package:login_page/Screens/Login/components/rounded_input_field.dart';
import 'package:login_page/Screens/Login/components/rounded_password_field.dart';

import 'package:login_page/Screens/SignUp/signup_screen.dart';
import 'package:login_page/absen.dart';
import 'package:login_page/components/rounded_button.dart';

final snackBarEmail = SnackBar(
  content: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("Email tidak terdaftar", textAlign: TextAlign.center),
  ),
);

final snackBarPassword = SnackBar(
  content: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text("Password Salah", textAlign: TextAlign.center),
  ),
);

class Body extends StatelessWidget {
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Your Email",
              controller: _emailController,
            ),
            RoundedPasswordField(controller: _passwordController),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Future<bool> berhasil = login(
                    _emailController.text, _passwordController.text, context);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  login(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PageAbsen(),
        ),
      );
      hapus();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(snackBarEmail);
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(snackBarPassword);
      }
    } catch (e) {
      print(e);
    }
  }

  hapus() {
    _emailController.text = '';
    _passwordController.text = '';
  }
}
