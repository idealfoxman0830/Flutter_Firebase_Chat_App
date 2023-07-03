
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;


  // for storing self info
  static late ChatUser me;
  // return current user
  static User get authuser => auth.currentUser!;

  // for checking user exist or not
  static Future<bool> userExists() async {
    return (await firestore
        .collection('users')
        .doc(authuser.uid)
        .get()).exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    return (await firestore
        .collection('users')
        .doc(authuser.uid)
        .get().then((user) async {
          if(user.exists){
            me = ChatUser.fromJson(user.data()!);
          }else {
              await createUser().then((value) => getSelfInfo());
            }
    }));
  }
  
  // for creating a new users

  static Future<void> createUser() async {

    final time = DateTime.now().millisecondsSinceEpoch.toString(); // it gives unique time

   final chatUser = ChatUser(image: authuser.photoURL.toString(), about: 'Hey i am using Flash Chat', name: authuser.displayName.toString(), createdAt: time, isOnline: false, lastActive: time, id: authuser.uid, email: authuser.email.toString(), pushToken: '');
   
    return await firestore.collection('users').doc(authuser.uid).set(chatUser.toJson());
  }


  // getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
   return firestore.collection('users').where('id',isNotEqualTo: authuser.uid).snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
     await firestore
        .collection('users')
        .doc(authuser.uid)
        .update({
       'name': me.name,
       'about': me.about,
     });
  }

  // update profile picture of user
  static Future<void> updateProfilePicture (File file)async {
       // getting file extension
    final ext = file.path.split('.').last;
    print('extension ${ext}');

    // storage file red with path
    final ref = firebaseStorage.ref().child('profile_pictures/${authuser.uid}.${ext}');
    //uploading image
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext'))
    .then((p0) {
      print('Data transferred : ${p0.bytesTransferred / 1000} kb');
    });
    // updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(authuser.uid)
        .update({
      'image': me.image,
    });
  }
  /// ************************* chatscreen***************

  // getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(){
    return firestore.collection('messages').snapshots();
  }

}
