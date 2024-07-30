import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController inputController;
  final String hintText;
  final bool isVisible;
  const InputTextField({
    super.key,
    required this.inputController,
    required this.hintText,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: width * .8,
        child: TextField(
          controller: inputController,
          cursorColor: Colors.blue,
          style: const TextStyle(fontSize: 20),
          obscureText: isVisible,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 19,fontWeight: FontWeight.w500),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 2,color: Colors.orange.shade300)
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1,color: Colors.orange.shade300)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2,color: Colors.orange.shade300)
            ),
          ),
        ),
      ),
    );
  }
}
