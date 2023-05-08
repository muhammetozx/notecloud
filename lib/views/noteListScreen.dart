// ignore_for_file: file_names, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notecloud/style/appStyle.dart';
import 'package:notecloud/views/noteReaderScreen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({Key? key}) : super(key: key);

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    //FirebaseAuth auth = FirebaseAuth.instance;
    //auth.currentUser?.uid,
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }
          /*  final DocumentSnapshot<Object?>? document = snapshot.data;
          final Object? documentData = document?.data();
          if(documentData['noteArray']){
            return Text('No item now');
          } */

          // final List<DocumentSnapshot> documents = result;
          //  final DocumentSnapshot document = snapshot.data;
          //   final Map<String, dynamic> documentData = document.data();
          //    final Map <String, dynamic> doc = snapshot.data;

          var documentData = snapshot.data;

          final itemDeteilList = (documentData!['noteArray'] as List)
              .map((itemDetail) => itemDetail as Map<String, dynamic>)
              .toList();
          if (itemDeteilList.isNotEmpty) {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: itemDeteilList.length,
              itemBuilder: (BuildContext context, int index) {
                final Map<String, dynamic> itemDetail = itemDeteilList[index];
                final String note_title = itemDetail['note_title'];
                final String note_content = itemDetail['note_content'];
                final DateTime creation_date =
                    (itemDetail['creation_date'] as Timestamp).toDate();
                final int color_id = itemDetail['color_id'];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NoteReaderScreen(),
                            settings: RouteSettings(
                                arguments: itemDeteilList[index])));
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        color: AppStyle.cardsColor[color_id],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$note_title', style: AppStyle.mainTitle),
                          SizedBox(height: 5),
                          Text('$note_content',
                              style: AppStyle.mainContent,
                              overflow: TextOverflow.ellipsis),
                          Spacer(),
                          Text(
                              '${creation_date.day.toString().padLeft(2, '0')}/${creation_date.month.toString().padLeft(2, '0')}/${creation_date.year}',
                              style: TextStyle(fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Text('boş');
        });
  }
}
