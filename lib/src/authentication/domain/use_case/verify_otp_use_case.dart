import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../repository/authentication_repository.dart';

@Injectable()
class VerifyOtpUseCase extends IUseCase<void, VerifyOtpParams> {
  final AuthenticationRepository _repository;

  VerifyOtpUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(VerifyOtpParams params) async {
    return await _repository.verifyOtp(params);
  }
}

class VerifyOtpParams {
  final String verificationCode;
  final OtpScreenCaseEnum verifyCase;

  const VerifyOtpParams({required this.verificationCode, required this.verifyCase});

  Map<String, dynamic> get toMap => {"code": verificationCode};
}

enum OtpScreenCaseEnum { register, updatePhone, login }

class OtpScreenArguments {
  final String phone;
  final OtpScreenCaseEnum caseEnum;
  final String? _illustration;

  OtpScreenArguments({required this.phone, required this.caseEnum, String? illustration}) : _illustration = illustration;

  String get illustration => _illustration ?? "AppIcons.fullLogo";
}
