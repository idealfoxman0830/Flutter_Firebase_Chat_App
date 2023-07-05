import 'package:flash_chat_flutter_with_firebase/screens/home_page.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
import 'api/apis.dart';
import 'screens/welcome_page.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  static const String id = '/';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _navigateToNextPage();
  }

  _navigateToNextPage() async{
    await Future.delayed(Duration(milliseconds: 9000),(){});
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // SystemChrome.setSystemUIOverlayStyle(
    //  const SystemUiOverlayStyle(systemNavigationBarColor: Colors.white, statusBarColor: Colors.white),
    // );


    final hasInternet = await InternetConnectivity().hasInternetConnection;
    if (hasInternet) {
      //You are connected to the internet
      if((await APIs.auth.currentUser !=null)){

        Navigator.pushReplacementNamed(context,HomePage.id);
      }else
      {
        // Navigator.pushNamed(context, WelcomePage.id);
        Navigator.pushReplacementNamed(context, WelcomePage.id);
      }

    } else {
      //"No internet connection
      Navigator.pushReplacementNamed(context, WelcomePage.id);
    }




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        //child: Text('Lottie Animation'),
        child: Lottie.network(
          'https://assets8.lottiefiles.com/packages/lf20_gbfwtkzw.json',
          repeat: true,
         // fit: BoxFit.fill,
          animate: true,
        ),

      ),
    );
  }
}
