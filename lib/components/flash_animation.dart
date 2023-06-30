import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class FlashAnimation extends StatefulWidget {
  const FlashAnimation({super.key});

  @override
  State<FlashAnimation> createState() => _FlashAnimationState();
}

class _FlashAnimationState extends State<FlashAnimation> {
  @override
  Widget build(BuildContext context) {
    return Text('lottie Animation');
    //   Lottie.network(
    //   'https://assets6.lottiefiles.com/datafiles/fxD5M12F5VtkZZ7/data.json',
    //   repeat: true,
    //   width: 180,
    //   height: 300,
    //   fit: BoxFit.fill,
    //   animate: true,
    // );
  }
}
