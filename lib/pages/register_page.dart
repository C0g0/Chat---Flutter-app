import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Create a ScrollController instance to control the scroll of the page
    final ScrollController scrollController = ScrollController();
    return Scaffold(
        body: SingleChildScrollView(
      controller: scrollController,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Logo(size: size),
            Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                    Future.delayed(const Duration(milliseconds: 200), () {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent + 100,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                    });
                  }
                },
                child: const _RegisterForm()),
            const Labels(
              question: 'Already have an account?',
              action: 'Login with your credentials',
              route: 'login',
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

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            prefixIcon: Icons.person,
            textController: nameController,
            hintText: 'Name',
          ),
          CustomInput(
            prefixIcon: Icons.mail,
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
          ),
          CustomInput(
            prefixIcon: Icons.lock,
            textController: passController,
            obscureText: true,
            hintText: 'Password',
          ),
          BlueButton(
            onPressed: authService.authenticating
                ? null
                : () async {
                    final isRegisterOk = await authService.register(
                        nameController.text.trim(),
                        emailController.text.trim(),
                        passController.text.trim());
                    if (isRegisterOk) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacementNamed(context, 'users');
                    } else {
                      // Show alert
                      // ignore: use_build_context_synchronously
                      showAlert(context, 'Register incorrect',
                          'Check your name, email and password');
                    }
                  },
            text: 'Register',
          )
        ],
      ),
    );
  }
}
