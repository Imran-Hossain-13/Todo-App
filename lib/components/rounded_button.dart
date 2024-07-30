import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool loading;
  const RoundedButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width * .8,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: loading == true? const CircularProgressIndicator():
          Text(title,style: const TextStyle(color: Colors.white,fontSize: 23,fontWeight: FontWeight.bold),),
        ),
      ),
    );
  }
}
