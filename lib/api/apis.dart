import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_flutter_with_firebase/models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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

}
