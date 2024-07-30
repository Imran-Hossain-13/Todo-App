import 'package:flutter/material.dart';

class Utils{
  static void showSnackMessage(BuildContext context, String msg){
    SnackBar sc = SnackBar(
      content: Text(msg,style: const TextStyle(fontSize: 17),),
      backgroundColor: Colors.blueAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(sc);
  }
}