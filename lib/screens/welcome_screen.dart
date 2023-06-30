// // import 'dart:ui';
// import 'package:animated_text_kit/animated_text_kit.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_core/firebase_core.dart';
// import 'package:flash_chat_flutter_with_firebase/api/apis.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/auth/login_screen.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/registration_screen.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flash_chat_flutter_with_firebase/components/rounded_button.dart';
//
// import 'home_page.dart';
//
// class WelcomeScreen extends StatefulWidget {
//   // static const String id = 'welcome_Screen';
//
//   const WelcomeScreen({super.key});
//
//   @override
//   State<WelcomeScreen> createState() => _WelcomeScreenState();
// }
//
// class _WelcomeScreenState extends State<WelcomeScreen> {
//   // late AnimationController controller;
//   // late Animation animation;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     try{
//       checkLogin();
//     //  controller.dispose();
//     }catch(e){
//       print(e);
//     }
//
//
//     // controller = AnimationController(
//     //   vsync: this,
//     //   duration: const Duration(seconds: 1),
//     //
//     //   // upperBound: 100.0,
//     // );
//
//     //animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
//
//     // animation =
//     //     ColorTween(begin: Colors.red, end: Colors.white).animate(controller);
//
//     //controller.forward();
//     // controller.addListener(() {
//     //   // we can add duration control value in everywhere
//     //   setState(() {});
//     // });
//   }
//     checkLogin() async {
//       if((await APIs.auth.currentUser !=null)){
//
//         Navigator.pushReplacement(context,
//           MaterialPageRoute(builder: (context)=> HomePage()),
//         );
//
//       }else
//       {
//         Navigator.pushNamed(context, WelcomePage.id);
//       }
//     }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//      // backgroundColor: animation.value, // .withOpacity(controller.value)
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 // Hero(
//                 //   tag: 'logo',
//                 //   child: SizedBox(
//                 //     height: 60.0,
//                 //     child: Image.asset('images/logo.png'),
//                 //   ),
//                 // ),
//                 // AnimatedTextKit(
//                 //     animatedTexts: [
//                 //   TypewriterAnimatedText(
//                 //     'Flash Chat',
//                 //     textStyle: const TextStyle(
//                 //       fontSize: 45.0,
//                 //       fontWeight: FontWeight.w900,
//                 //     ),
//                 //
//                 //   ),
//                 // ] // ${controller.value.toInt()}%
//                 //
//                 //     ),
//               ],
//             ),
//             const SizedBox(
//               height: 48.0,
//             ),
//              RoundedButton(
//               onPressed: (){
//                 Navigator.pushNamed(context, LoginScreen.id);
//               },
//                colour:Colors.lightBlueAccent,
//                title: 'Log In',
//             ),
//             // color: Colors.blueAccent,   'Register'                     Navigator.pushNamed(context, RegistrationScreen.id);
//             RoundedButton(
//               onPressed: (){
//                 Navigator.pushNamed(context, RegistrationScreen.id);
//               },
//               colour:Colors.blueAccent,
//               title: 'Register',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
