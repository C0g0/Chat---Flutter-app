import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  // Text controller to handle the text field
  final _textController = TextEditingController();
  // Focus node to handle the focus of the text field
  final _focusNode = FocusNode();
  // Boolean to check if the user is writing
  var _isWriting = false;
  // List to store the messages
  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: size.height * 0.1,
          centerTitle: true,
          elevation: 1,
          title: Column(
            children: [
              // CircleAvatar widget to display the user's profile picture
              CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: const Text('Te'),
              ),
              const SizedBox(height: 3),
              const Text(
                'Luis Cogollo',
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        body: Column(
          children: [
            Flexible(
                child: ListView.builder(
              // physics to bounce when scrolling
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (_, index) {
                return _messages[index];
              },
              reverse: true,
            )),
            const Divider(height: 1),
            Container(
              color: Colors.white,
              height: size.height * 0.05,
              child: _inputChat(),
            )
          ],
        ));
  }

  // Text field widget to write messages
  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              onChanged: (_) {
                setState(() {
                  _isWriting =
                      _textController.text.trim().isNotEmpty ? true : false;
                });
              },
              decoration: InputDecoration.collapsed(
                  hintText: 'Send message',
                  hintStyle: TextStyle(color: Colors.grey[400])),
              focusNode: _focusNode,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _isWriting
                        ? () => _handleSubmitted(_textController.text.trim())
                        : null,
                    child: const Text('Send'),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: const IconThemeData(color: Colors.blue),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: _isWriting
                            ? () =>
                                _handleSubmitted(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  // Method to handle the submission of the text field
  _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = ChatMessage(
      texto: text,
      uid: '123',
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
  }

  // Method to dispose the animation controllers
  @override
  void dispose() {
    //TODO: implement dispose sockets
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
