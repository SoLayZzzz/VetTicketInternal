import 'package:vet_internal_ticket/view/auth/data/model/response/auth_refresh_token.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/logout_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/user_data.dart';

abstract class UserRepository {
  bool isLogin();
  LoginResponse loginResponse();
  void setLoginResponse(LoginResponse loginResponse);
  void setLogOutResponse(LogoutResponse logOutResponse);
  void setLoginRefreshToken(AuthRefreshTokenResponse authRefreshToken);
  void setLoginCheckPermission();
  void setLoginCheckToken();
  void setLoginGetReportToken();

  AppConfig appConfig();
  void setAppConfig(AppConfig appConfig);
  void clear();
}
