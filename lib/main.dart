import 'package:chat/routes/routes.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the MaterialApp with MultiProvider
    return MultiProvider(
      // Add ChangeNotifierProvider for AuthService
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
        theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 43, 151, 237),
          scaffoldBackgroundColor: const Color(0xfff2f2f2),
        ),
      ),
    );
  }
}
