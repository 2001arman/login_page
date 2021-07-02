import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login_page/Screens/Login/components/already_have_an_account_check.dart';
import 'package:login_page/Screens/Login/components/rounded_input_field.dart';
import 'package:login_page/Screens/Login/components/rounded_password_field.dart';
import 'package:login_page/Screens/Login/login_screen.dart';
import 'package:login_page/Screens/SignUp/components/background.dart';
import 'package:login_page/Screens/SignUp/components/or_divider.dart';
import 'package:login_page/Screens/SignUp/components/social_icon.dart';
import 'package:login_page/components/rounded_button.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late String username, password;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final snackBarBerhasil = SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Berhasil Membuat akun", textAlign: TextAlign.center),
    ),
  );
  final snackBarPassword = SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Password Lemah", textAlign: TextAlign.center),
    ),
  );
  final snackBarEmail = SnackBar(
    content: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text("Email Sudah Pernah Digunakan", textAlign: TextAlign.center),
    ),
  );

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            RoundedInputField(
              hintText: "Your Email",
              controller: _emailController,
            ),
            RoundedPasswordField(
              controller: _passwordController,
            ),
            SizedBox(
              height: size.height * 0.03,
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                _daftar(_emailController.text, _passwordController.text);
              },
            ),
            AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                }),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialIcon(
                  iconSrc: "assets/icons/facebook.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/twitter.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "assets/icons/google-plus.svg",
                  press: () {},
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _daftar(String username, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: username, password: password);

      ScaffoldMessenger.of(context).showSnackBar(snackBarBerhasil);
      hapus();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(snackBarPassword);
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(snackBarEmail);
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
