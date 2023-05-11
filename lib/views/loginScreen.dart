import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notecloud/views/forgotPasswordScreen.dart';
import 'package:notecloud/views/homeScreen.dart';
import 'package:notecloud/views/signUpScreen.dart';
import 'package:sign_button/sign_button.dart';

import '../utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController =
      TextEditingController(text: 'muhammetozx@icloud.com');
  TextEditingController passwordTextEditingController =
      TextEditingController(text: '123456');
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: emailTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Email',
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  prefixIcon: Icon(Icons.email),
                  prefixIconColor: Colors.blueAccent,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: passwordTextEditingController,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.blueAccent),
                  prefixIcon: Icon(Icons.password),
                  prefixIconColor: Colors.blueAccent,
                  suffixIconColor: Colors.blueAccent,
                  suffixIcon: GestureDetector(
                    child: obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                    onTap: () {
                      setState(
                        () {
                          obscureText = !obscureText;
                        },
                      );
                    },
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {},
              child: Container(
                  alignment: Alignment.topCenter,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgotPasswordScreen()));
                    },
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  emailLogin();
                },
                child: Text("Login"),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => signUpScreen()));
              },
              child: Container(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Don't have an account SignUp",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            SignInButton.mini(
              buttonType: ButtonType.google,
              buttonSize: ButtonSize.medium,
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

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set(
        {
          'userInfo': {
            'name_surname': userCredential.user!.displayName,
            'email': userCredential.user!.email,
            'imageLink': userCredential.user!.photoURL,
          },
        },
        SetOptions(merge: true),
      );

      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set(
        {
          'noteArray': FieldValue.arrayUnion([]),
        },
        SetOptions(merge: true),
      );

              Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen(),
                settings:
                    RouteSettings(arguments: {'info': googleUser, 'type': 'google'})),
            (Route<dynamic> route) => false);

              
      print(googleUser.displayName);
      print(googleUser.email);
      print(googleUser.photoUrl);
    } catch (error) {
      print(error);
    }
  }

//settings: RouteSettings(arguments: googleUser)
  emailLogin() async {
    var loginEmail = emailTextEditingController.text.trim();
    var loginPassword = passwordTextEditingController.text.trim();

    try {
      User? firebaseUser = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: loginEmail, password: loginPassword))
          .user;

      if (firebaseUser != null) {
        final snaps = await FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.email)
            .get();
        final info = snaps.data();

        /*  Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomeScreen(),
            settings:
                RouteSettings(arguments: {'info': info, 'type': 'email'}))); */

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => HomeScreen(),
                settings:
                    RouteSettings(arguments: {'info': info, 'type': 'email'})),
            (Route<dynamic> route) => false);
      } else {
        print("Check email & password");
      }
    } on FirebaseAuthException catch (e) {
      print('error $e');
    }
  }
}
