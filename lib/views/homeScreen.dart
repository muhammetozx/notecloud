// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notecloud/views/addNoteScreem.dart';
import 'package:notecloud/views/loginScreen.dart';
import 'package:notecloud/views/noteListScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            SizedBox(width: 5),
            Text(
              user.displayName!,
              style: TextStyle(fontSize: 15),
            ),
            Spacer(),
            IconButton(
                onPressed: () {
                  logout();
                },
                icon: Icon(Icons.exit_to_app_outlined)),
          ],
        ),
      ),
        
      body: NoteListScreen(),
      
      
      
       /* StreamBuilder<QuerySnapshot> (
                stream: FirebaseFirestore.instance.collection('Users/email/noteArray').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if(snapshot.hasData){
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2 ),
                        children: snapshot.data.docs
                        .map((note) => noteCard((){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteReaderScreen(note)));
                        }, note)).toList(),
                    );
                  }
                  return Text("ther's no Notes", style: GoogleFonts.nunito(color: Colors.white));
                },
              ), */
        
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNoteScreen()));
        },
        backgroundColor: Colors.grey[100],
        child: Icon(Icons.add),
      ),
    );
  }

  logout() async {
    await GoogleSignIn().disconnect();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    print("Çıkış yapıldı");
  }
}
