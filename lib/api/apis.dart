import 'dart:async';

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';
import 'package:flash_chat_flutter_with_firebase/models/message.dart';

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
    return (await firestore.collection('users').doc(authuser.uid).get()).exists;
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    return (await firestore
        .collection('users')
        .doc(authuser.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    }));
  }

  // for creating a new users

  static Future<void> createUser() async {
    final time = DateTime.now()
        .millisecondsSinceEpoch
        .toString(); // it gives unique time

    final chatUser = ChatUser(
        image: authuser.photoURL.toString(),
        about: 'Hey i am using Flash Chat',
        name: authuser.displayName.toString(),
        createdAt: time,
        isOnline: false,
        lastActive: time,
        id: authuser.uid,
        email: authuser.email.toString(),
        pushToken: '');

    return await firestore
        .collection('users')
        .doc(authuser.uid)
        .set(chatUser.toJson());
  }

  // getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: authuser.uid)
        .snapshots();
  }

  // for updating user information
  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(authuser.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }


  // update profile picture of user
  static Future<void> updateProfilePicture(File file) async {
    // getting file extension
    final ext = file.path.split('.').last;
    print('extension ${ext}');

    // storage file red with path
    final ref =
        firebaseStorage.ref().child('profile_pictures/${authuser.uid}.${ext}');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data transferred : ${p0.bytesTransferred / 1000} kb');
    });
    // updating image in firestore database
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(authuser.uid).update({
      'image': me.image,
    });
  }


  // for getting specific picture of user
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
   static Future<void> updateActiveStatus(bool isOnline) async{
     firestore
         .collection('users')
         .doc(authuser.uid).update(
         {
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString()
    });
   }


  /// ************************* chat-screen***************
  // chats(collection) --> conversation_id(doc) --> messages(collection) --> message(doc)

  // useful for getting conversational id
  static String getConversationalID(String id) =>
      authuser.uid.hashCode <= id.hashCode
          ? '${authuser.uid}_$id'
          : '${id}_${authuser.uid}';

  // getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
         return firestore
        .collection('chats/${getConversationalID(user.id)}/messages/')
             .orderBy('sent',descending: true)
        .snapshots();
  }
  // for sending message | Doc id will be the message sending id

  static Future<void> sendMessage(ChatUser chatUserID, String msg,Type type) async {
    // message sending time (also used as uid)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    // message to send

    final Message message = Message(
        msg: msg,
        read: '',
        told: chatUserID.id,
        type: type,
        sent: time,
        fromId: authuser.uid);

    final ref = firestore
        .collection('chats/${getConversationalID(chatUserID.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }
// update read status of message

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationalID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }
  
  // get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(ChatUser user){
     return firestore
        .collection('chats/${getConversationalID(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
}

// send chat image
  static Future<void> sendChatImage(ChatUser chatUser,File file)async {
    // getting file extension
    final ext = file.path.split('.').last;
    print('extension ${ext}');

    // storage file red with path
    final ref =
    firebaseStorage.ref().child('images/${getConversationalID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.${ext}');
    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      print('Data transferred : ${p0.bytesTransferred / 1000} kb');
    });
    // updating image in firestore database
    final imageURL = await ref.getDownloadURL();
    await sendMessage(chatUser, imageURL, Type.image);
    }


}
