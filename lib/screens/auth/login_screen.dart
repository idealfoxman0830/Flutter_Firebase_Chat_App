
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter_with_firebase/components/rounded_button.dart';
import 'package:flash_chat_flutter_with_firebase/constants.dart';

// LoginScreen

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  // _handleGoogebtnClick() {
  //   _signInWithGoogle().then((user) async {
  //     if (user != null) {
  //       log('User ${user.user}');
  //
  //       if ((await APIs.userExists())) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(builder: (_) => HomePage()),
  //         );
  //       } else {
  //         await APIs.createUser().then((value) => {
  //               Navigator.pushReplacement(
  //                 context,
  //                 MaterialPageRoute(builder: (_) => HomePage()),
  //               )
  //             });
  //       }
  //     }
  //
  //   });
  // }

  // signingReport

  // Future<UserCredential?> _signInWithGoogle() async {
  //   try {
  //     await InternetAddress.lookup('google.com');
  //     // Trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //
  //     // Obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;
  //
  //     // Create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //
  //     // Once signed in, return the UserCredential
  //     return await APIs.auth.signInWithCredential(credential);
  //   } catch (e) {
  //     // Dialogs.snackBar;
  //     Dialogs.showSnackbar(context);
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Hero(
            //   tag: 'logo',
            //   child: SizedBox(
            //     height: 200.0,
            //     child: Image.asset('images/logo.png'),
            //   ),
            // ),
            const SizedBox(
              height: 20.0,
            ),
           //FlashAnimation(),

            const SizedBox(
              height: 5.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Password'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            RoundedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              colour: Colors.blueAccent,
              title: 'Login',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'If your are already Logged in ',
                  style: TextStyle(fontSize: 18.0),
                ),
                GestureDetector(
                  onTap: ()  {
                    // if ((await APIs.auth.currentUser != null)) {
                    //   Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => HomePage()),
                    //   );
                    // } else {
                    //   Navigator.pushNamed(context, WelcomePage.id);
                    // }
                  },
                  child: Text(
                    'Click Here',
                    style: TextStyle(fontSize: 20.0, color: Colors.blueAccent),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
