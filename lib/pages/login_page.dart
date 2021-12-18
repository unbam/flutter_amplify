import 'package:flutter/material.dart';

import '../models/analytics_events.dart';
import '../models/auth_credentials.dart';
import '../services/analytics_service.dart';

///
/// ログインページ
///
class LoginPage extends StatefulWidget {
  const LoginPage(
      {Key? key,
      required this.shouldShowSignUp,
      required this.didProvideCredentials})
      : super(key: key);

  final ValueChanged<LoginCredentials> didProvideCredentials;
  final VoidCallback shouldShowSignUp;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: Stack(
          children: [
            // Login Form
            _loginForm(),
            // Sign Up Button
            Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: widget.shouldShowSignUp,
                child: const Text("Don't have an account? Sign up."),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// ログインフォーム
  ///
  Widget _loginForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Username TextField
        TextField(
          controller: _usernameController,
          decoration: const InputDecoration(
              icon: Icon(Icons.mail), labelText: 'Username'),
        ),
        // Password TextField
        TextField(
          controller: _passwordController,
          decoration: const InputDecoration(
              icon: Icon(Icons.lock_open), labelText: 'Password'),
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
        // Login Button
        ElevatedButton(
          onPressed: _login,
          child: const Text('Login'),
        ),
      ],
    );
  }

  ///
  /// ログイン
  ///
  void _login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final credentials =
        LoginCredentials(username: username, password: password);
    widget.didProvideCredentials(credentials);
    AnalyticsService.log(LoginEvent());
  }
}
