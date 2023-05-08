// ignore_for_file: file_names, prefer_const_constructors

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notecloud/views/homeScreen.dart';
import '../style/appStyle.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({Key? key}) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  int colorId = Random().nextInt(AppStyle.cardsColor.length);
  DateTime date = new DateTime.now();
  TextEditingController titleTextControllter = TextEditingController();
  TextEditingController mainTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorId],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[colorId],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Row(
          children: [
            Text("Add a new Note", style: TextStyle(color: Colors.black)),
            Spacer(),
            IconButton(
                onPressed: () {
                  //orderAdd();
                  noteAdd();
                   Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  size: 25,
                ))
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: titleTextControllter,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Title",
              ),
              style: AppStyle.mainTitle,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}",
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 28.0,
            ),
            TextField(
              controller: mainTextController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note Content",
              ),
            ),
          ],
        ),
      ),
    );
  }

  final user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth auth = FirebaseAuth.instance;
  noteAdd() {
    FirebaseFirestore.instance.collection('Users')
    .doc(user.email).set(
      {'noteArray': FieldValue.arrayUnion(
        [{
          'userId': auth.currentUser?.uid,
          'note_title': titleTextControllter.text,
          'creation_date': date,
          'note_content': mainTextController.text,
          'color_id': colorId,
        }]),
      },
      SetOptions(merge: true),
    );
  }



}


 /*
  orderAdd() {
    FirebaseFirestore.instance.collection('Users').doc(user.email).set({
      'userId.name': auth.currentUser?.uid,
      'note_title': titleTextControllter.text,
      'creation_date': date,
      'note_content': mainTextController.text,
      'color_id': colorId,
    });
  }*/

/*
  noteAdd() {
    FirebaseFirestore.instance.collection("Users").add({
      "note_title": titleTextControllter.text,
      //"creation_date": date,
      "note_content": mainTextController.text,
      "color_id": colorId,
    });
  }
}
*/