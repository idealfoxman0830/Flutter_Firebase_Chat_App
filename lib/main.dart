import 'package:flash_chat_flutter_with_firebase/screens/chat_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/auth/login_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/home_page.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/home_page.dart';
import 'package:flash_chat_flutter_with_firebase/screens/registration_screen.dart';
import 'package:flash_chat_flutter_with_firebase/screens/welcome_page.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/welcome_screen.dart';
// import 'package:flash_chat_flutter_with_firebase/splash.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/services.dart';
// import 'home.dart';
import 'splash.dart';

 late Size mq;

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();
    runApp( const FlashChat()
    );

}

class FlashChat extends StatefulWidget {
  const FlashChat({super.key});

  @override
  State<FlashChat> createState() => _FlashChatState();
}
class _FlashChatState extends State<FlashChat> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // color: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
     // home: Splash(),
      routes: {
        Splash.id: (context) => const Splash(),
        HomePage.id: (context) => const HomePage(),
        LoginScreen.id: (context) => const LoginScreen(),
        RegistrationScreen.id: (context) => const RegistrationScreen(),
        // ChatScreen.id: (context) => const ChatScreen(),
        WelcomePage.id:(context) => const WelcomePage(),
      },
     // initialRoute: '/',

    );
  }
}
