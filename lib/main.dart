import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/chat_service.dart';

import 'package:chat/routes/routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with MultiProvider
    return MultiProvider(
      providers: [
        // Add ChangeNotifierProvider for AuthService
        ChangeNotifierProvider(create: (_) => AuthService()),
        // Add ChangeNotifierProvider for SocketService
        ChangeNotifierProvider(create: (_) => SocketService()),
        // Add ChangeNotifierProvider for ChatService
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 1,
            backgroundColor: Colors.white,
          ),
          primaryColor: const Color.fromARGB(255, 43, 151, 237),
          scaffoldBackgroundColor: const Color(0xfff2f2f2),
        ),
      ),
    );
  }
}
