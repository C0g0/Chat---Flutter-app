import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController textController;
  final bool? obscureText;
  final TextInputType? keyboardType;
  const CustomInput({
    super.key,
    this.keyboardType = TextInputType.text,
    required this.prefixIcon,
    required this.textController,
    this.obscureText = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 20),
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: 5,
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 5))
        ], borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: TextFormField(
          controller: textController,
          autocorrect: false,
          obscureText: obscureText ?? false,
          keyboardType: keyboardType,
          decoration: InputDecoration(
              prefixIcon: Icon(prefixIcon),
              border: InputBorder.none,
              hintText: hintText),
        ));
  }
}
