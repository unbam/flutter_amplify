import 'package:flutter/material.dart';

import '../models/analytics_events.dart';
import '../services/analytics_service.dart';

///
/// 検証ページ
///
class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key, required this.didProvideVerificationCode})
      : super(key: key);

  final ValueChanged<String> didProvideVerificationCode;

  @override
  State<StatefulWidget> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 40),
        child: _verificationForm(),
      ),
    );
  }

  Widget _verificationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Verification Code TextField
        TextField(
          controller: _verificationCodeController,
          decoration: const InputDecoration(
              icon: Icon(Icons.confirmation_number),
              labelText: 'Verification code'),
        ),
        // Verify Button
        ElevatedButton(
          onPressed: _verify,
          child: const Text('Verify'),
        ),
      ],
    );
  }

  void _verify() {
    final verificationCode = _verificationCodeController.text.trim();
    widget.didProvideVerificationCode(verificationCode);
    AnalyticsService.log(VerificationEvent());
  }
}
