
// import 'package:flash_chat_flutter_with_firebase/main.dart';
import 'dart:convert';
import 'dart:developer';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/screens/profile_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
// import 'package:flash_chat_flutter_with_firebase/api/apis.dart';
import 'package:flash_chat_flutter_with_firebase/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = "home_screen";


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return firestore.collection('users').snapshots();
  }

  List<ChatUser> list=[];


  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(CupertinoIcons.home),
        title: Text('Flash Chat'),
        actions: [
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(CupertinoIcons.search),),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(user: list[0],)));
          }, icon: Icon(CupertinoIcons.ellipsis_vertical),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            print('signout');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );

        },
        child: Icon(CupertinoIcons.person_add,
        size: 25.0,
        ),

      ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getUsersStream(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            
           
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {

              // for(var i in data!){
              //   print('data : ${jsonEncode(i.data())}');
              // }

              return Center(
                child: CircularProgressIndicator(),
              );
            }

           // final List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = snapshot.data!.docs;
            final documents = snapshot.data!.docs;
            list = documents.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

              if(list.isNotEmpty){
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    //  final user = documents[index].data();

                    return ChatUserCard(
                      chatUser: list[index],
                    );
                  },
                );
              }
              return Center(
                child: Text('No Connections Found!',
                style: TextStyle(
                  fontSize: 20,
                ),
                ),
              );
          },
        )
    );
  }
}
