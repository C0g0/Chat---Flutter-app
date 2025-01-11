import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Create a function showAlert that receives a BuildContext, a title, and a message
showAlert(BuildContext context, String title, String message) {
  if (Platform.isAndroid) {
    // Show an AlertDialog with the title and message
    return showDialog(
      context: context,
      //  Create an AlertDialog with the title and message
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          // Create a MaterialButton with the text 'Ok' that pops the context
          MaterialButton(
            elevation: 5,
            textColor: Colors.blue,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
  // If the platform is iOS, show a CupertinoAlertDialog
  showCupertinoDialog(
      context: context,
      // Create a CupertinoAlertDialog with the title and message
      builder: (_) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          ));
}
