import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;

    // Create a ScrollController instance to control the scroll of the page
    final ScrollController scrollController = ScrollController();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                height: size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Logo(size: size),
                    // Focus the input when the keyboard is shown and scroll the page
                    Focus(
                        onFocusChange: (hasFocus) {
                          if (hasFocus) {
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              scrollController.animateTo(
                                  scrollController.position.maxScrollExtent +
                                      100,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut);
                            });
                          }
                        },
                        child: const _LoginForm()),
                    const Labels(
                      question: 'Don\'t have an account?',
                      action: 'Create one now',
                      route: 'register',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text('Tems & Conditions'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // Get the AuthService instance
    final authService = Provider.of<AuthService>(context);

    // Get the SocketService instance
    final socketService = Provider.of<SocketService>(context);

    final size = MediaQuery.of(context).size;

    return Container(
      margin: EdgeInsets.only(top: size.height * 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // Email
          CustomInput(
            prefixIcon: Icons.mail,
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
          ),
          // Password
          CustomInput(
            prefixIcon: Icons.lock,
            textController: passController,
            obscureText: true,
            hintText: 'Password',
          ),
          // LoginButton
          BlueButton(
            onPressed: authService.authenticating
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final isLoginOk = await authService.login(
                        emailController.text.trim(),
                        passController.text.trim());
                    if (isLoginOk) {
                      // Connect the socket
                      socketService.connect();
                      // Navigate to the users page
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      // Show an error message
                      // ignore: use_build_context_synchronously
                      showAlert(context, 'Login incorrect',
                          'Check your email and password');
                    }
                  },
            text: 'Login',
          )
        ],
      ),
    );
  }
}
