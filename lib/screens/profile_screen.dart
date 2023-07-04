// import 'package:flash_chat_flutter_with_firebase/main.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
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
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text('Profile Screen'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.redAccent,
          onPressed: () async {
            Dialogs.showProgressBar(context);
            await APIs.updateActiveStatus(false);
            await APIs.auth.signOut();
            await GoogleSignIn().signOut();
            Navigator.pop(context);
            // await APIs.auth.signOut().then((value) async{
            // await GoogleSignIn().signOut().then((value){
            //   // for hiding progress dialog
            //   Navigator.pop(context);
            //   // for moving to home screen
            //   Navigator.pop(context);
            //
            //   // replacing home screen with welcome screen
            //  // Navigator.pushReplacementNamed(context, WelcomePage.id);
            //
            //  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> WelcomePage()));
            // });
            // });
            Dialogs.showSnackbar(context, 'Successfully Log-out');
            print('sign-out');
            APIs.auth = FirebaseAuth.instance;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
          label: Text('Logout'),
          icon: Icon(Icons.logout),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: mediaQuery.size.width * .05),
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height * .05,
                ),
                Stack(
                  children: [
                    // profile picture
                    _image != null
                        ? ClipOval( // local image
                            child: CircleAvatar(
                              radius: 90,
                              child: Image.file(
                                File(_image!),
                                width: mediaQuery.size.width * .70,
                                height: mediaQuery.size.height * .70,
                                fit: BoxFit.cover,


                              ),
                            ),
                          )
                        : ClipOval( // image from server
                            child: CircleAvatar(
                              radius: 90,
                              child: FadeInImage.assetNetwork(
                                image: widget
                                    .user.image, // replace with your image URL
                                width: mediaQuery.size.width * .70,
                                height: mediaQuery.size.height * .70,
                                fit: BoxFit.cover,
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Icon(Icons
                                      .error); // display an error icon when image fails to load
                                },
                                placeholder: 'images/logo.png',
                              ),
                            ),
                          ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        elevation: 1,
                        color: Colors.white,
                        shape: CircleBorder(),
                        child: Icon(
                          Icons.edit,
                          color: Colors.blue,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mediaQuery.size.height * .02,
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * .04,
                ),
                TextFormField(
                  initialValue: widget.user.name,
                  onSaved: (value) => APIs.me.name = value ?? '',
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Required field',
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'eg. Soumik',
                    label: Text('Name'),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * .02,
                ),
                TextFormField(
                  initialValue: widget.user.about,
                  onSaved: (value) => APIs.me.about = value ?? '',
                  validator: (value) => value != null && value.isNotEmpty
                      ? null
                      : 'Required field',
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'eg. Feeling Happy',
                    label: Text('About'),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * .03,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      APIs.updateUserInfo().then((value) {
                        Dialogs.showSnackbar(
                            context, 'Info update successfully');
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    minimumSize: Size(
                        mediaQuery.size.width * .5, mediaQuery.size.width * .1),
                  ),
                  icon: Icon(
                    Icons.system_update_alt,
                    size: 25,
                  ),
                  label: Text(
                    'UPDATE',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 20, bottom: 20),
            children: [
              Text(
                'Pick a Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
                        if (image != null) {
                          print('image path : ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(80, 80),
                      ),
                      child: Image.asset('images/adding.png')),
                  ElevatedButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image =
                        await picker.pickImage(source: ImageSource.camera,imageQuality: 80);
                        if (image != null) {
                          print('image path : ${image.path}');
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                        fixedSize: Size(80, 80),
                      ),
                      child: Image.asset('images/camera.png'))
                ],
              ),
            ],
          );
        });
  }
}
