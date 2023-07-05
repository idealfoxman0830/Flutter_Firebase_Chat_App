import 'package:flash_chat_flutter_with_firebase/screens/home_page.dart';
// import 'package:flash_chat_flutter_with_firebase/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
// import 'package:flutter/services.dart';
// import 'package:lottie/lottie.dart';
import 'api/apis.dart';
import 'helper/dialogs.dart';
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
     Dialogs.showSnackbar(context, 'Please check Internet Connection');
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Center(
        //child: Text('Lottie Animation'),
        child: SplashImageLottie(),
      ),
    );
  }
}




class SplashImageLottie extends StatelessWidget {
  const SplashImageLottie({super.key});

  @override
  Widget build(BuildContext context) {

    Future<Widget> splashImage() async {
      final hasInternet = await InternetConnectivity().hasInternetConnection;
      if (hasInternet) {
        // You are connected to the internet
        return Lottie.network(
          'https://assets8.lottiefiles.com/packages/lf20_gbfwtkzw.json',
          repeat: true,
          // width: 100,
          // height: 320,
          fit: BoxFit.cover,
          animate: true,
        );
      } else {
        // No internet connection
        SystemNavigator.pop();
        return Future.error('No internet connection');
      }
    }
    return FutureBuilder<Widget>(
      future: splashImage(),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurred, handle it accordingly
          return Text('Error: ${snapshot.error}');
        } else {
          // If the future completed successfully, return the widget
          return snapshot.data!;
        }
      },
    );

  }
}