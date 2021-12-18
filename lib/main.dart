import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';

import 'amplifyconfiguration.dart';
import 'pages/camera_flow.dart';
import 'pages/login_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/verification_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _amplify = Amplify;
  final _authService = AuthService();

  @override
  void initState() {
    _configureAmplify();
    _authService.checkAuthStatus();
    super.initState();
  }

  Future<void> _configureAmplify() async {
    try {
      await _amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyStorageS3(),
        AmplifyAnalyticsPinpoint(),
      ]);
      await _amplify.configure(amplifyconfig);
      debugPrint('Successfully configured Amplify 🎉');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Amplify App',
      theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity),
      home: StreamBuilder<AuthState>(
        stream: _authService.authStateController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Navigator(
              pages: [
                // Show Login Page
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.login)
                  MaterialPage<dynamic>(
                    child: LoginPage(
                      shouldShowSignUp: _authService.showSignUp,
                      didProvideCredentials: _authService.loginWithCredentials,
                    ),
                  ),
                // Show Sign Up Page
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.signUp)
                  MaterialPage<dynamic>(
                    child: SignUpPage(
                      shouldShowLogin: _authService.showLogin,
                      didProvideCredentials: _authService.signUpWithCredentials,
                    ),
                  ),
                // Show Verification Code Page
                if (snapshot.data!.authFlowStatus ==
                    AuthFlowStatus.verification)
                  MaterialPage(
                    child: VerificationPage(
                      didProvideVerificationCode: _authService.verifyCode,
                    ),
                  ),
                // Show Camera Flow
                if (snapshot.data!.authFlowStatus == AuthFlowStatus.session)
                  MaterialPage(
                    child: CameraFlow(shouldLogOut: _authService.logOut),
                  )
              ],
              onPopPage: (route, result) => route.didPop(result),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
