import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  TextEditingController nameSurnameEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 350,
              child: TextFormField(
                controller: nameSurnameEditingController,
                decoration: InputDecoration(
                  hintText: 'Name Surname',
                  labelText: 'Name Surname',
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
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
            SizedBox(height: 20.0),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  signUpEmail();
                },
                child: Text("SignUp"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signUpEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
        .then((user) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(emailTextEditingController.text)
          .set(
        {
          'userInfo': {
            'name_surname': nameSurnameEditingController.text,
            'email': emailTextEditingController.text,
            'password': passwordTextEditingController.text,
          },
        },
        SetOptions(merge: true),
      );
    });
    FirebaseFirestore.instance
        .collection('Users')
        .doc(emailTextEditingController.text)
        .set(
      {
        'noteArray': FieldValue.arrayUnion([]),
      },
      SetOptions(merge: true),
    );
  }
}
