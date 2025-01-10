import 'package:chat/routes/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'chat',
      routes: appRoutes,
      theme: ThemeData(
          primaryColor: const Color.fromARGB(255, 43, 151, 237),
          scaffoldBackgroundColor: const Color(0xfff2f2f2),
          filledButtonTheme: const FilledButtonThemeData(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 43, 151, 237))))),
    );
  }
}
