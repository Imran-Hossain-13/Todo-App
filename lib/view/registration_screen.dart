import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_project/components/input_text_field.dart';
import 'package:tutorial_project/components/rounded_button.dart';
import 'package:tutorial_project/utils/Utils.dart';
import 'package:tutorial_project/view_model/register_model/register_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios,size: 40,)
            ),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Register yourself",style: TextStyle(fontSize: 29,fontWeight: FontWeight.bold),),
                SizedBox(height: height * .07,),
                InputTextField(
                  inputController: emailController,
                  hintText: "Enter email",
                ),
                InputTextField(
                  inputController: passwordController,
                  hintText: "Enter password",
                  isVisible: true,
                ),
                const SizedBox(height: 30,),
                ChangeNotifierProvider(
                  create: (_) => RegisterController(),
                  child: Consumer<RegisterController>(
                    builder: (context, provider, child){
                      return RoundedButton(
                        onTap: (){
                          if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                            provider.registerUser(context, emailController.text, passwordController.text);
                            emailController.clear();
                            passwordController.clear();
                          }else{
                            Utils.showSnackMessage(context, "Enter email and password");
                          }
                        },
                        title: "Register",
                        loading: provider.loading,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
