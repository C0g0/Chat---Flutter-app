import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;

  const ChatMessage(
      {super.key,
      required this.texto,
      required this.uid,
      required this.animationController});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    // widget that allows you to animate the size of the widget
    return SizeTransition(
      sizeFactor:
          CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      // widget that allows you to animate the opacity of the widget
      child: FadeTransition(
        opacity: animationController,
        child: Container(
          child: uid == authService.user!.uid
              ? _myMessage(context)
              : _notMyMessage(context),
        ),
      ),
    );
  }

  Widget _myMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(left: size.width * 0.3, bottom: 5, right: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff4D9EF6)),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _notMyMessage(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.only(left: 5, bottom: 5, right: size.width * 0.3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 168, 169, 171)),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
