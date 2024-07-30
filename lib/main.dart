import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_project/view/home_screen.dart';
import 'package:tutorial_project/view/login_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  runApp(MyApp(token: preferences.getString('token'),));
}

class MyApp extends StatelessWidget {
  final token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: (token != null && JwtDecoder.isExpired(token) == false) ?HomeScreen(token: JwtDecoder.decode(token)):const LoginScreen(),
    );
  }
}

