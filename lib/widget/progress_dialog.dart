import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  String message;
  ProgressDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[400],
      child: Container(
        margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white, //
          borderRadius: BorderRadius.circular(6.0),
        ),child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: [
           CircularProgressIndicator(
             valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
           ),
           SizedBox(width: 15.0,),
           Text(message, style:TextStyle(color: Colors.red[400],fontSize: 16.0))

            
          ],),
        ),
      ),
    );
  }
}
