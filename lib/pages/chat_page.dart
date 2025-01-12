import 'dart:io';

import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  // chat service
  ChatService chatService = ChatService();

  // socket service
  SocketService socketService = SocketService();

  AuthService authService = AuthService();

  void _listenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
      texto: payload['message'],
      uid: payload['from'],
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('personal-message', (data) => _listenMessage(data));

    _loadMessages(chatService.userTo!.uid);
  }

  void _loadMessages(String uid) async {
    List<Message> chat = await chatService.getMessages(uid);
    final history = chat.map((message) => ChatMessage(
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
          texto: message.message,
          uid: message.from,
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final userTo = chatService.userTo;
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
                child: Text(userTo!.name.substring(0, 2)),
              ),
              const SizedBox(height: 3),
              Text(
                userTo.name,
                style: const TextStyle(fontSize: 14),
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
      uid: authService.user!.uid,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });

    socketService.socket.emit('personal-message', {
      'from': authService.user?.uid,
      'to': chatService.userTo!.uid,
      'message': text,
    });
  }

  // Method to dispose the animation controllers
  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    // To close the connection with the socket and stop to listen for messages
    socketService.socket.off('personal-message');
    super.dispose();
  }
}
