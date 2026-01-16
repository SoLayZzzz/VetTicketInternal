import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';

class AuthState {
  String errorLogin;
  String errorMessage;
  bool isLoading;
  bool isPass;
  int status;
  LoginResponse? loginResponse;
  bool isEnter;

  AuthState({
    this.errorLogin = "Invalid username or password",
    this.errorMessage = "",
    this.isLoading = false,
    this.isPass = true,
    this.status = 200,
    this.loginResponse,
    this.isEnter = false,
  });

  AuthState copyWith({
    String? errorLogin,
    String? errorMessage,
    bool? isLoading,
    bool? isPass,
    int? status,
    LoginResponse? loginResponse,
    bool? isEnter,
  }) {
    return AuthState(
      errorLogin: errorLogin ?? this.errorLogin,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading ?? this.isLoading,
      isPass: isPass ?? this.isPass,
      status: status ?? this.status,
      loginResponse: loginResponse ?? this.loginResponse,
      isEnter: isEnter ?? this.isEnter,
    );
  }
}
