import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String question;
  final String action;
  final String route;
  const Labels(
      {super.key,
      required this.question,
      required this.action,
      required this.route});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          question,
          style: const TextStyle(
              color: Colors.black45, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, route);
          },
          child: Text(
            action,
            style: const TextStyle(
                color: Color.fromARGB(255, 43, 151, 237),
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
