import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: const EdgeInsets.only(top: 50),
          width: size.width * 0.6,
          child: const Image(
              image: AssetImage(
            'assets/logo-chat.png',
          ))),
    );
  }
}
