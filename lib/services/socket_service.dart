import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';

// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  // Connect the socket
  void connect() async {
    // Get the token from the AuthService
    final token = await AuthService.getToken();

    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoconect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    // Detect when the server is online
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    // Detect when the server is offline
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
    // ignore: avoid_print
    _socket.on('new-message', (data) => print('new message: $data'));
  }

  // Disconnect the socket
  void disconnect() {
    _socket.disconnect();
  }
}
