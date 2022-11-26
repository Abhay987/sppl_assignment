import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

/// Loading Dialog
class ShowLoadingAlertDialog extends StatelessWidget {

  const ShowLoadingAlertDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        backgroundColor: Colors.grey[400],
        content: Row(
          children: const[
            CircularProgressIndicator(color: Colors.blue,),
            SizedBox(width: 20,),
            Text('Loading...',style: TextStyle(color: Colors.blue),),
          ],
        ),                                       // actionsAlignment: MainAxisAlignment.spaceBetween,
      );
    }
    else {
      return CupertinoAlertDialog(
        content: Row(
          children: const[
            CircularProgressIndicator(color: Colors.blue,),
            SizedBox(width: 20,),
            Text('Loading...',style: TextStyle(color: Colors.blue),),
          ],
        ),
      );
    }
  }
}