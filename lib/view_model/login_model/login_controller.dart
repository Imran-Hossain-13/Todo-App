import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_project/res/app_url.dart';
import 'package:tutorial_project/view/home_screen.dart';
import '../../utils/Utils.dart';

class LoginController extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> loginUser(context, String email, String password) async{
    setLoading(true);
    var logBody = {
      'email' : email,
      'password' : password,
    };
    var response = await http.post(
      Uri.parse(loginUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(logBody),
    );
    var jsonResponse = jsonDecode(response.body);
    if(jsonResponse['status']){
      setLoading(false);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var token = jsonResponse['token'];
      preferences.setString('token', token);
      Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(token);
      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen(
      //   userEmail: jwtDecodeToken['email'],
      //   userId: jwtDecodeToken['email'],
      // )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen(token:  jwtDecodeToken,)));
    }else{
      setLoading(false);
      Utils.showSnackMessage(context, "User login failed");
    }
  }
}