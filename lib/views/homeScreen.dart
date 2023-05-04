import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notecloud/views/addNoteScreem.dart';
import 'package:notecloud/views/loginScreen.dart';

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
      body: Center(
        child: Column(
          children: [],
        ),
      ),
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
