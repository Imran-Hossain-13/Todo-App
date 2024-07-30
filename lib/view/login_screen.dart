import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_project/view/registration_screen.dart';
import 'package:tutorial_project/view_model/login_model/login_controller.dart';
import '../components/input_text_field.dart';
import '../components/rounded_button.dart';
import '../utils/Utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Fill form for login",
                  style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: height * .07,
                ),
                InputTextField(
                  inputController: emailController,
                  hintText: "Enter email",
                ),
                InputTextField(
                  inputController: passwordController,
                  hintText: "Enter password",
                  isVisible: true,
                ),
                const SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                  create: (_) => LoginController(),
                  child: Consumer<LoginController>(
                    builder: (context, provider, child){
                      return RoundedButton(
                        onTap: () {
                          if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
                            provider.loginUser(context, emailController.text, passwordController.text);
                            emailController.clear();
                            passwordController.clear();
                          } else {
                            Utils.showSnackMessage(
                                context, "Enter email and password");
                          }
                        },
                        title: "Login",
                        loading: provider.loading,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: height * .02,
                ),
                SizedBox(
                  width: width * .8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Don't have an account? ",style: TextStyle(fontSize: 15),),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const RegistrationScreen()));
                        },
                        child: const Text("Register",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)
                      ),
                    ],
                  ),
                )
                // ChangeNotifierProvider(
                //   create: (_) => RegisterController(),
                //   child: Consumer<RegisterController>(
                //     builder: (context, provider, child){
                //       return RoundedButton(
                //         onTap: (){
                //           if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                //             provider.registerUser(emailController.text, passwordController.text);
                //           }else{
                //             Utils.showSnackMessage(context, "Enter email and password");
                //           }
                //         },
                //         title: "Register",
                //         loading: provider.loading,
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
