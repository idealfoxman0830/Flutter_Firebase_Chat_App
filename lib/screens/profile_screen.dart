
// import 'package:flash_chat_flutter_with_firebase/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../models/chat_user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user});
  static const String id = "profile_screen";
  final ChatUser user;


  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getUsersStream() {
    return firestore.collection('users').snapshots();
  }



  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile Screen'),

      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.redAccent,
        onPressed: () async{
           Dialogs.showSnackbar(context);
          await APIs.auth.signOut().then((value) async{
          await GoogleSignIn().signOut().then((value){
            // for hiding progress dialog
            Navigator.pop(context);
            // for moving to home screen
            Navigator.pop(context);

            // replacing home screen with welcome screen
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WelcomePage()));
          });
          });

            print('sign-out');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );

        },
        label: Text('Logout'),
        icon: Icon(Icons.logout),

        ),

        body:Padding(
          
          padding: EdgeInsets.symmetric(horizontal: mediaQuery.size.width * .05),
          child: Column(
            children:[
              SizedBox(
                width: mediaQuery.size.width,
                  height: mediaQuery.size.height *.05,
              ),
              Stack(
                children: [
                  ClipOval(
                    child: CircleAvatar(
                      radius: 90,
                      child: FadeInImage.assetNetwork(
                        image: widget.user.image, // replace with your image URL
                        width: mediaQuery.size.width * .70,
                        height: mediaQuery.size.height * .70,
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error); // display an error icon when image fails to load
                        },  placeholder: 'images/logo.png',
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: MaterialButton(onPressed: (){},
                      elevation: 1,
                      color: Colors.white,
                      shape: CircleBorder(),
                    child: Icon(Icons.edit,
                      color:Colors.blue,size: 25,),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: mediaQuery.size.height *.02,
              ),
              Text(widget.user.email,
              style: TextStyle(
                color: Colors.black,fontSize: 20,
              ),
              ),
              SizedBox(
                height: mediaQuery.size.height *.04,
              ),
              TextFormField(
                initialValue: widget.user.name,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,color: Colors.blue,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'eg. Soumik',
                  label: Text('Name'),
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height *.02,
              ),
              TextFormField(
                initialValue: widget.user.about,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description,color: Colors.blue,),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'eg. Feeling Happy',
                  label: Text('About'),
                ),
              ),
              SizedBox(
                height: mediaQuery.size.height *.03,
              ),
              ElevatedButton.icon(onPressed: (){},
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  minimumSize: Size(mediaQuery.size.width * .5, mediaQuery.size.width * .1),
                ),
                  icon: Icon(Icons.edit,size: 25,), label: Text('UPDATE',style: TextStyle(
                  fontSize: 20,
                ),),
              
              )
            ]
          ),
        ),
    );
  }
}