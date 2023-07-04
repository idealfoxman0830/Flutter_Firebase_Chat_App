// import 'package:flash_chat_flutter_with_firebase/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/screens/profile_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
import 'package:flash_chat_flutter_with_firebase/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  //
  // Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
  //   return firestore.collection('users').snapshots();
  // }
  // for storing all users
  List<ChatUser> list = [];
  // for storing search items
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.getSelfInfo();
    APIs.updateActiveStatus(true);
    /*
    * for updating user active status according to lifecycle events
    * resume -- active or online
    * pause -- inactive or offline
    * **/

    SystemChannels.lifecycle.setMessageHandler((message){

      if(APIs.auth.currentUser != null){
        if(message.toString().contains('pause')){
          APIs.updateActiveStatus(false);
        }
        if(message.toString().contains('resume')){
          APIs.updateActiveStatus(true);
        }
      }



      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              leading: Icon(CupertinoIcons.home),
              title: _isSearching
                  ? TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name,Email ...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onChanged: (val) {
                        _searchList.clear();
                        for (var i in list) {
                          if (i.name
                                  .toLowerCase()
                                  .contains(val.toLowerCase()) ||
                              (i.email
                                  .toLowerCase()
                                  .contains(val.toLowerCase()))) {
                            _searchList.add(i);
                          }
                          setState(() {
                            _searchList;
                          });
                        }
                      },
                      autofocus: true,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  : Text('Flash Chat'),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                    });
                  },
                  icon: Icon(_isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : CupertinoIcons.search),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: Icon(CupertinoIcons.ellipsis_vertical),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
                print('sign-out');
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: Icon(
                CupertinoIcons.person_add,
                size: 25.0,
              ),
            ),
            body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: APIs.getAllUsers(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                list = documents
                        .map((e) => ChatUser.fromJson(e.data()))
                        .toList() ??
                    [];

                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount:
                        _isSearching ? _searchList.length : documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      //  final user = documents[index].data();

                      return ChatUserCard(
                        chatUser:
                            _isSearching ? _searchList[index] : list[index],
                      );
                    },
                  );
                }
                return Center(
                  child: Text(
                    'No Connections Found!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                );
              },
            ),
        ),
      ),
    );
  }
}
