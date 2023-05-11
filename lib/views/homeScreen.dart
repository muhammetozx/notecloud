// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously, avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notecloud/views/addNoteScreen.dart';
import 'package:notecloud/views/loginScreen.dart';
import 'package:notecloud/views/noteListScreen.dart';
import 'package:notecloud/views/profileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var info;
  late String type;

  @override
  void initState() {
    super.initState();
  }

  Future opening() async {
    if ((ModalRoute.of(context)!.settings.arguments as Map)['type'] ==
        'google') {
      info = (ModalRoute.of(context)!.settings.arguments as Map)['info']
          as GoogleSignInAccount;
      type = 'google';
    } else {
      info = (ModalRoute.of(context)!.settings.arguments as Map)['info']
          ['userInfo'];
      type = 'email';
    }
    await Future.delayed(Duration.zero);
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: opening(),
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen()));
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(type == 'google'
                          ? (info as GoogleSignInAccount).photoUrl
                          : info['imageLink']),
                    ),
                  ),
                  SizedBox(width: 5),
                  /* Text(
                    type == 'google'
                        ? (info as GoogleSignInAccount).email
                        : info['email'],
                    style: TextStyle(fontSize: 15),
                  ), */
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        logout();
                        //emailSignOut();
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  logout() async {
    if (await GoogleSignIn().isSignedIn())
      await GoogleSignIn().disconnect();
    else
      await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
    print("Çıkış yapıldı");
  }

  /* emailSignOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
          (Route<dynamic> route) => false);
    });
  } */
}
