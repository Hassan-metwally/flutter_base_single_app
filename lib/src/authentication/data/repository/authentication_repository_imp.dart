import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repository/authentication_repository.dart';
import '../../domain/use_case/register_use_case.dart';
import '../../domain/use_case/can_update_phone_use_case.dart';
import '../../domain/use_case/login_use_case.dart';
import '../../domain/use_case/resend_otp_use_case.dart';
import '../../domain/use_case/verify_otp_use_case.dart';
import '../models/api_authentication_response.dart';
import '../models/api_user_model.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImp implements AuthenticationRepository {
  final DioHelper _apiHelper;
  final SecureStorageRepository _secureStorageRepository;

  const AuthenticationRepositoryImp(this._apiHelper, this._secureStorageRepository);

  @override
  DomainServiceType<UserEntity> login(LoginParams params) async {
    return await failureCollect(() async {
      final response = await _apiHelper.post(url: ApiConstants.apiUrl("auth/login"), body: await params.toMap);
      final user = ApiLoggedUserResponse.fromJson(response['data']);
      await _secureStorageRepository.setToken(user.getAsValidTokenEntity);
      return Right(user.user.map);
    });
  }

  @override
  DomainServiceType<void> register(RegisterParams params) async {
    return await failureCollect(() async {
      final response = await _apiHelper.post(url: ApiConstants.apiUrl("auth/register"), body: await params.toMap);
      final data = ApiLoggedUserResponse.fromJson(response['data']);
      final token = data.getTokenForSingleSession;
      await _secureStorageRepository.setToken(token);
      await _secureStorageRepository.setCachedUser(data.user.map.mapToCacheEntity);
      return const Right(null);
    });
  }

  @override
  DomainServiceType<void> verifyOtp(VerifyOtpParams params) async {
    return await failureCollect<void>(() async {
      switch (params.verifyCase) {
        case OtpScreenCaseEnum.register:
        case OtpScreenCaseEnum.login:
          final result = await _apiHelper.post(url: ApiConstants.apiUrl("auth/verify-otp"), body: params.toMap);
          final UserEntity user = ApiUserModel.fromJson(result['data']).map;
          await _secureStorageRepository.setCachedUser(user.mapToCacheEntity);
          break;
        case OtpScreenCaseEnum.updatePhone:
          await _apiHelper.post(url: ApiConstants.apiUrl("auth/verify-otp"), body: params.toMap);
          await _secureStorageRepository.deleteAllCache();
      }
      return const Right(null);
    });
  }

  @override
  DomainServiceType<void> resendOtp(ResendOtpParams params) async {
    return await failureCollect<void>(() async {
      await _apiHelper.post(url: ApiConstants.apiUrl("auth/resend-otp"), body: params.toMap);
      return const Right(null);
    });
  }

  @override
  DomainServiceType<void> logOut() async {
    return await failureCollect<void>(() async {
      await _apiHelper.post(url: ApiConstants.apiUrl("auth/logout"));
      await _secureStorageRepository.deleteAllCache();
      return const Right(null);
    });
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    return await failureCollect<void>(() async {
      await _apiHelper.delete(url: ApiConstants.apiUrl("auth/delete-account"));
      await _secureStorageRepository.deleteAllCache();
      return const Right(null);
    });
  }

  @override
  DomainServiceType<void> canUpdateMobile(CanUpdatePhoneParams params) async {
    return await failureCollect<void>(() async {
      await _apiHelper.post(url: ApiConstants.apiUrl("auth/change-mobile"), body: params.toMap);
      return const Right(null);
    });
  }

  /// Common Services
  ///

  // @override
  // DomainServiceType<void> forgotPassword(ForgotPasswordParams params) async {
  //   return await failureCollect<void>(() async {
  //     final result = await _apiHelper.post(url: "auth/forget-password", body: params.toMap);
  //     final tokenValue = result["data"]["access_token"];
  //     final token = TokenModel.forSingleSession(token: tokenValue);
  //     await _secureStorageRepository.setToken(token);
  //     return const Right(null);
  //   });
  // }

  // @override
  // DomainServiceType<void> resetPassword(ResetPasswordParams params) async {
  //   return await failureCollect<void>(() async {
  //     await _apiHelper.post(url: "auth/reset-password", body: params.toMap);
  //     await _secureStorageRepository.deleteAllCache();
  //     return const Right(null);
  //   });
  // }

  // @override
  // DomainServiceType<void> updatePassword(UpdatePasswordParams params) async {
  //   return await failureCollect<void>(() async {
  //     await _apiHelper.post(url: "auth/change-password", body: params.toMap);
  //     await _secureStorageRepository.deleteAllCache();
  //     return const Right(null);
  //   });
  // }
}
