import 'package:chat/pages/pages.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
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
    // Get the instance of the AuthService with listen: false to avoid listening to changes
    final authService = Provider.of<AuthService>(context, listen: false);

    // Get the instance of the SocketService with listen: false to avoid listening to changes
    final SocketService socketService =
        Provider.of<SocketService>(context, listen: false);
    final authenticated = await authService.isLoggedIn();

    // If the user is authenticated, connect to the socket server and navigate to the users page
    if (authenticated) {
      // Connect to our socket server
      socketService.connect();
      // Navigate to the users page
      Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const UsersPage(),
            transitionDuration: const Duration(milliseconds: 0),
          ));
    } else {
      // Navigate to the login page
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
