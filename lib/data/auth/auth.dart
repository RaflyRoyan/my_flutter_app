/// Padanan `AuthVM.LoginResponse` di CekReklameApi.
class LoginResponse {
  const LoginResponse({required this.isResetPassword, required this.token});

  final bool isResetPassword;
  final String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    isResetPassword: json['isResetPassword'] == true,
    token: json['token'] as String? ?? '',
  );
}
