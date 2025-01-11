import 'package:chat/pages/pages.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();
    if (authenticated) {
      // Connect to our socket server
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const UsersPage(),
            transitionDuration: const Duration(milliseconds: 0),
          ));
    } else {
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const LoginPage(),
            transitionDuration: const Duration(milliseconds: 0),
          ));
    }
  }
}
