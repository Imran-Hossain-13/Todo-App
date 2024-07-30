import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tutorial_project/res/app_url.dart';
import '../../utils/Utils.dart';

class HomeController extends ChangeNotifier{
  bool _loading = false;
  bool get loading => _loading;

  List _responseData = [];
  List get responseData => _responseData;

  String _updateTitleController = '';
  String get updateTitleController => _updateTitleController;
  String _updateDescController = '';
  String get updateDescController => _updateDescController;

  setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

  setResponseData(data){
    _responseData = data;
    notifyListeners();
  }

  removeResponseData(index){
    _responseData.remove(index);
    notifyListeners();
  }

  setController(title, description){
    if(title != ''){
      _updateTitleController = title;
    }
    if(description != ''){
      _updateDescController = description;
    }
  }


  Future<void> storeData(context,String userId, String title, String description) async{
    setLoading(true);
    var todoBody = {
      'userId' : userId,
      'title' : title,
      'description' : description,
    };
    var response = await http.post(
      Uri.parse(todoUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(todoBody),
    );
    var decodeResponse = json.decode(response.body);
    if(decodeResponse['status']){
      setLoading(false);
      Navigator.pop(context);
    }else{
      setLoading(false);
      Utils.showSnackMessage(context, "User registration failed");
    }
  }

  Future<List<dynamic>> getTodoData(userId)async{
    var todoBody = {
      'userId' : userId,
    };
    var response = await http.post(
      Uri.parse(getUserListUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(todoBody),
    );
    var decodeResponse = json.decode(response.body);
    setResponseData(decodeResponse['data']);
    return decodeResponse['data'];
  }

  Future<void> updateTodoData(context,dataId, String title, String description)async{
    setLoading(true);
    var todoBody = {
      'dataId' : dataId,
      'title' : title,
      'description' : description,
    };
    var response = await http.post(
      Uri.parse(dataUpdateUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(todoBody),
    );
    var decodeResponse = json.decode(response.body);
    if(decodeResponse['status']){
      setLoading(false);
      Navigator.pop(context);
    }else{
      setLoading(false);
      Utils.showSnackMessage(context, "Data update failed");
    }
  }


  Future<void> deleteTodoData(context,dataId,index)async{
    setLoading(true);
    var todoBody = {
      'dataId' : dataId,
    };
    var response = await http.post(
      Uri.parse(deleteDataUrl),
      headers : {"Content-Type" : 'application/json'},
      body: jsonEncode(todoBody),
    );
    var decodeResponse = json.decode(response.body);

    if(decodeResponse['status']){
      removeResponseData(index);
      setLoading(false);
    }else{
      setLoading(false);
      Utils.showSnackMessage(context, "Data delete failed");
    }
  }
}
