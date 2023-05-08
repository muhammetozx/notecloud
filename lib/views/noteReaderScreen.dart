import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notecloud/style/appStyle.dart';
import 'package:intl/intl.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen({Key? key}) : super(key: key);
  //QueryDocumentSnapshot doc;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  @override
  Widget build(BuildContext context) {
    Map itemDetailsList = ModalRoute.of(context)!.settings.arguments as Map;

    //Timestamp convert to date.
    Timestamp t = (itemDetailsList['creation_date'] as Timestamp);
    DateTime date = t.toDate();

    int color_id = itemDetailsList['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              itemDetailsList['note_title'].toString(),
              style: AppStyle.mainTitle,
            ),
            SizedBox(height: 10.0),
            Text(
              '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}',
              style: AppStyle.dateTitle,
            ),
            SizedBox(height: 28.0),
            Text(
              itemDetailsList["note_content"].toString(),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
    );
  }
}
