import 'package:vet_internal_ticket/core/base/header.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/logOut_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_body.dart';
import 'package:vet_internal_ticket/view/auth/data/model/request/login_refreshToken_body_request.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_checkToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_get_reportToken.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_permission.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/auth_refresh_token.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/login_response.dart';
import 'package:vet_internal_ticket/view/auth/data/model/response/logout_response.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';

abstract class AuthRepository {
  Future<Header<LoginResponse>?> login(LoginUserPasswordBody loginBody);
  Future<Header<LogoutResponse>?> logOut(LogoutBody body);
  Future<Header<AuthRefreshTokenResponse>?> loginRefreshToken(
      LoginRefreshTokenBodyRequest body);
  Future<Header<AuthCheckPermissionResponse>?> loginCheckPermission();
  Future<Header<AuthCheckTokenResponse>?> loginCheckToken();
  Future<Header<AuthGetReportTokenResponse>?> loginGetReportToken();

  UserRepository get userRepository;
}
