// import 'package:flash_chat_flutter_with_firebase/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/helper/dialogs.dart';
import 'package:flash_chat_flutter_with_firebase/screens/profile_screen.dart';
import 'package:flash_chat_flutter_with_firebase/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api/apis.dart';
import '../main.dart';
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
    mq = MediaQuery.of(context).size;
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
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     _showMessageUpdateDialog();
            //   },
            //   child: Icon(
            //     CupertinoIcons.person_add,
            //     size: 25.0,
            //   ),
            // ),
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

  // add chat user dialog
  // void _showMessageUpdateDialog() {
  //   String email = '';
  //
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //         contentPadding: const EdgeInsets.only(
  //             left: 24, right: 24, top: 20, bottom: 10),
  //
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20)),
  //
  //         //title
  //         title: Row(
  //           children: const [
  //             Icon(
  //               Icons.person,
  //               color: Colors.blue,
  //               size: 28,
  //             ),
  //             Text('Add User')
  //           ],
  //         ),
  //
  //         //content
  //         content: TextFormField(
  //           maxLines: null,
  //           onChanged: (value) => email = value,
  //           decoration: InputDecoration(
  //             hintText: 'Add Email',
  //             prefixIcon: Icon(Icons.email),
  //               border: OutlineInputBorder(
  //                   borderRadius: BorderRadius.circular(15))),
  //         ),
  //
  //         //actions
  //         actions: [
  //           //cancel button
  //           MaterialButton(
  //               onPressed: () {
  //                 //hide alert dialog
  //                 Navigator.pop(context);
  //               },
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.blue, fontSize: 16),
  //               )),
  //
  //           //Add button
  //           MaterialButton(
  //               onPressed: () async {
  //                 //hide alert dialog
  //                 Navigator.pop(context);
  //                if(email.isNotEmpty){
  //                 await APIs.addChatUser(email).then((value){
  //                   if(!value){
  //                     Dialogs.showSnackbar(context,'User does not exist');
  //                   }
  //                 });
  //                }
  //               },
  //               child: const Text(
  //                 'Add',
  //                 style: TextStyle(color: Colors.blue, fontSize: 16),
  //               ))
  //         ],
  //       ));
  // }
}

