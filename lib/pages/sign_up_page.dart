import 'package:flutter/material.dart';

import '../models/analytics_events.dart';
import '../models/auth_credentials.dart';
import '../services/analytics_service.dart';

///
/// サインアップページ
///
class SignUpPage extends StatefulWidget {
  const SignUpPage(
      {Key? key,
      required this.shouldShowLogin,
      required this.didProvideCredentials})
      : super(key: key);

  final ValueChanged<SignUpCredentials> didProvideCredentials;
  final VoidCallback shouldShowLogin;

  @override
  State<StatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          children: [
            // Sign Up Form
            _signUpForm(),
            // Login Button
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                  onPressed: widget.shouldShowLogin,
                  child: const Text('Already have an account? Login.')),
            )
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
              icon: Icon(Icons.person), labelText: 'Username'),
        ),
        // Email TextField
        TextField(
          controller: _emailController,
          decoration:
              const InputDecoration(icon: Icon(Icons.mail), labelText: 'Email'),
        ),
        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        // Sign Up Button
        ElevatedButton(
          onPressed: _signUp,
          style: TextButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary),
          child: const Text('Sign Up'),
        )
      ],
    );
  }

  ///
  /// サインアップ
  ///
  void _signUp() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final credentials =
        SignUpCredentials(username: username, email: email, password: password);
    widget.didProvideCredentials(credentials);
    AnalyticsService.log(SignUpEvent());
  }
}
