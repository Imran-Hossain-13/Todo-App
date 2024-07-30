import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutorial_project/res/app_url.dart';
import '../../utils/Utils.dart';

class RegisterController extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  Future<void> registerUser(context, String email, String password) async{
    setLoading(true);
    var regBody = {
      'email' : email,
      'password' : password,
    };
    var response = await http.post(
      Uri.parse(registrationUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(regBody),
    );
    if(response.statusCode == 200){
      setLoading(false);
    }else{
      setLoading(false);
      Utils.showSnackMessage(context, "User registration failed");
    }
    var decodedData = jsonDecode(response.body);
    // print(decodedData['status']);
  }
}