import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notecloud/utils.dart';
import 'package:notecloud/views/loginScreen.dart';

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
  Uint8List? image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? downloadUrl;

  uploadImageToStorage() async {
    Reference ref = storage
        .ref()
        .child("UsersProfilePhoto")
        .child(emailTextEditingController.text);
    UploadTask uploadTask = ref.putData(image!);
    TaskSnapshot snapshot = await uploadTask;
    downloadUrl = await snapshot.ref.getDownloadURL();
    print("${downloadUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50),
              Stack(
                children: [
                  image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(
                              "lib/assets/images/standartUserImages.jpg")),
                  Positioned(
                    child: IconButton(
                        onPressed: () {
                          selectImage();
                        },
                        icon: Icon(Icons.add_a_photo)),
                    bottom: -10,
                    left: 80,
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
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
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
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
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
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
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1),
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Kayıt başarılı"),
                      duration: Duration(seconds: 2),
                    ));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("SignUp"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  signUpEmail() async {
    //-------------------------
    Reference ref = storage
        .ref()
        .child("UsersProfilePhoto")
        .child(emailTextEditingController.text);
    UploadTask uploadTask = ref.putData(image!);
      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();
      print("${downloadUrl}");
    
    //-----------------------------
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
            'imageLink': downloadUrl,
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
