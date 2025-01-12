import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: size.height * 0.05),
          width: size.width * 0.6,
          child: const Image(
              image: AssetImage(
            'assets/logo-chat.png',
          ))),
    );
  }
}
