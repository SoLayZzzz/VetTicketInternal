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
import 'package:vet_internal_ticket/view/auth/data/network/auth_network_data_source.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/auth_repository.dart';
import 'package:vet_internal_ticket/view/auth/domain/repsositories/user_repository.dart';

class UserPasswordAuthRepositoryimpl extends AuthRepository {
  final AuthNetworkDataSource authNetworkDataSource;
  final UserRepository _userRepository;

  UserPasswordAuthRepositoryimpl(
      this.authNetworkDataSource, this._userRepository);

  @override
  UserRepository get userRepository => _userRepository;
  //
  @override
  Future<Header<LoginResponse>?> login(LoginBody loginBody) =>
      authNetworkDataSource
          .loginUserPassword(loginBody as LoginUserPasswordBody)
          .then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLoginResponse(value!.body!);
        }
        return value;
      });

  @override
  Future<Header<LogoutResponse>?> logOut(LogoutBody body) =>
      authNetworkDataSource.logOut(body).then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLogOutResponse(value!.body!);
        }
        return value;
      });

  @override
  Future<Header<AuthRefreshTokenResponse>?> loginRefreshToken(
          LoginRefreshTokenBodyRequest body) =>
      authNetworkDataSource.loginRefreshToken(body).then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLoginRefreshToken(value!.body!);
        }
        return value;
      });

  @override
  Future<Header<AuthCheckPermissionResponse>?> loginCheckPermission() =>
      authNetworkDataSource.loginCheckPermission().then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLoginCheckPermission();
        }
        return value;
      });

  @override
  Future<Header<AuthCheckTokenResponse>?> loginCheckToken() =>
      authNetworkDataSource.loginCheckToken().then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLoginCheckToken();
        }
        return value;
      });

  @override
  Future<Header<AuthGetReportTokenResponse>?> loginGetReportToken() =>
      authNetworkDataSource.loginGetReportToken().then((value) {
        if (value?.statusCode == 200) {
          userRepository.setLoginGetReportToken();
        }
        return value;
      });
}
