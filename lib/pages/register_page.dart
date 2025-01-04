import 'package:chat/widgets/widgets.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            const _RegisterForm(),
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
  const _RegisterForm({
    super.key,
  });

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {},
            text: 'Register',
          )
        ],
      ),
    );
  }
}
