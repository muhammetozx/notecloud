import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notecloud/views/homeScreen.dart';
import 'package:sign_button/sign_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SignInButton(
              buttonType: ButtonType.google,
              buttonSize: ButtonSize.large,
              imagePosition: ImagePosition.right,
              btnTextColor: Colors.black54,
              width: 300,
              onPressed: () {
                googleLogin();
              },
            ),
          ],
        ),
      ),
    );
  }

  googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      var googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()));
      print(googleUser.displayName);
      print(googleUser.email);
      print(googleUser.photoUrl);
    } catch (error) {
      print(error);
    }
  }
}
