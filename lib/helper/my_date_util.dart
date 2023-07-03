import 'package:flutter/material.dart';

class MyDateUtil{

  //getting formatted time from milisecondsSinceEpochs String

  static String getFromattedTime({required BuildContext context,required String time}){
     final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
     return TimeOfDay.fromDateTime(date).format(context);
  }

}