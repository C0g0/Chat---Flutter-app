import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  const BlueButton({
    super.key,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: const ButtonStyle(
        elevation: WidgetStatePropertyAll(2),
      ),
      child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ))),
    );
  }
}
