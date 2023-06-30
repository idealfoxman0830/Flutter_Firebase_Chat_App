import 'package:flutter/material.dart';

class Dialogs {

  static void showSnackbar(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Please! check your internet connection',
      style: TextStyle(
        color: Colors.white,
      ),
      ),
      backgroundColor: Colors.lightBlue,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));

  }

  static void showProgressBar(BuildContext context){
    showDialog(context: context, builder: (_)=> Center(child: CircularProgressIndicator()));
  }
}
