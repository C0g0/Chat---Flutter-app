import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final MaterialColor? backgroundColor;
  const BlueButton({
    super.key,
    this.onPressed,
    required this.text,
    this.backgroundColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey; // Set the color for the disabled state
          }
          return Colors.blue; // Default color
        }),
        elevation: const WidgetStatePropertyAll(2),
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
