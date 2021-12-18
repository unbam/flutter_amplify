abstract class AuthCredentials {
  AuthCredentials({required this.username, required this.password});
  final String username;
  final String password;
}

class LoginCredentials extends AuthCredentials {
  LoginCredentials({required String username, required String password})
      : super(username: username, password: password);
}

class SignUpCredentials extends AuthCredentials {
  SignUpCredentials(
      {required String username, required String password, required this.email})
      : super(username: username, password: password);
  final String email;
}
