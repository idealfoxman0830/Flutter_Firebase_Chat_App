

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter_with_firebase/screens/auth/login_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/registration_screen.dart';
import 'package:flash_chat_flutter_with_firebase/components/rounded_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:lottie/lottie.dart';
import 'package:flash_chat_flutter_with_firebase/main.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import 'home_page.dart';

class WelcomePage extends StatefulWidget {

  const WelcomePage({super.key});
  static const String id = 'welcome_page';


  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
//  var size,height,width;


  _handleGoogleBtnCLick(){
    _signInWithGoogle().then((user) async {



      if(user != null){

        if((await APIs.userExists())){
          Navigator.pushReplacementNamed(context, HomePage.id);

         }else{
          await APIs.createUser().then((value){
            Navigator.pushReplacementNamed(context, HomePage.id);

          });
         }


      }



    } );
  }


  Future<UserCredential?> _signInWithGoogle() async {

    try{
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    }catch(e){
      // Dialogs.snackBar;
      Dialogs.showSnackbar(context,'Please! check your internet connection');
    }
    return null;
  }

  // signInWithGoogle() async{
  //   GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //   GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
  //       AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleAuth?.accessToken,
  //         idToken: googleAuth?.idToken,
  //       );
  //
  //       UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //       print(userCredential.user?.displayName);
  //
  // }



  @override
  Widget build(BuildContext context) {
     mq = MediaQuery.of(context).size;
    // getting the size of the window
    // size = MediaQuery.of(context).size;
    // height = size.height;
    // width = size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Lottie.network(
              //   'https://assets4.lottiefiles.com/packages/lf20_1pxqjqps.json',
              //   repeat: true,
              //   width: 100,
              //   height: 320,
              //   fit: BoxFit.fill,
              //   animate: true,
              // ),

              Text('Welcome to Flash Chat',
             textAlign: TextAlign.center,
                style:TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),

                 // fontStyle: FontStyle.italic,

              ),
             const SizedBox(
               height: 20,
             ),

              // Lottie.asset(
              //   'assets/lottie_file.json',
              //   repeat: true,
              //   reverse: true,
              //   animate: true,
              // ),


             RoundedButton(
                 onPressed: (){
                   Navigator.pushNamed(context, LoginScreen.id);
                 },
               colour: Colors.blueAccent,
               title: 'Login',

             ),
             RoundedButton(
               onPressed: (){
                 Navigator.pushNamed(context, RegistrationScreen.id);
               },
               colour:Colors.orange.shade400,
               title: 'Register',
             ),

              const SizedBox(
                height: 10.0,
              ),

              Material(
                elevation: 5.0,
                color: Colors.cyanAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                 _handleGoogleBtnCLick();
                 //  signInWithGoogle();
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Login With Google'
                    ,style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
