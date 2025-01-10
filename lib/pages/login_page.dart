import 'package:flutter/material.dart';

import 'package:chat/widgets/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo(size: size),
            const _LoginForm(),
            const Labels(
              question: 'Don\'t have an account?',
              action: 'Create one now',
              route: 'register',
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text('Tems & Conditions'),
            ),
          ],
        ),
      ),
    ));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({
    super.key,
  });

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    return Container(
      margin: const EdgeInsets.only(top: 40),
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
            onPressed: () {},
            text: 'Login',
          )
        ],
      ),
    );
  }
}
