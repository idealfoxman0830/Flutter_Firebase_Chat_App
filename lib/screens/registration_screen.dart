import 'package:flash_chat_flutter_with_firebase/components/flash_animation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_flutter_with_firebase/components/rounded_button.dart';
import 'package:flash_chat_flutter_with_firebase/constants.dart';
import 'package:lottie/lottie.dart';

//RegistrationScreen

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

          //  FlashAnimation(),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Password'),
            ),
            const SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              colour:Colors.orange.shade400,
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
