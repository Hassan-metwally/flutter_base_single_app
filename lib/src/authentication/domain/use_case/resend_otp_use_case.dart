import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../repository/authentication_repository.dart';

@Injectable()
class ResendOtpUseCase extends IUseCase<void, ResendOtpParams> {
  final AuthenticationRepository _repository;

  ResendOtpUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ResendOtpParams params) async {
    return await _repository.resendOtp(params);
  }
}

class ResendOtpParams extends NoParams {
  final String phone;

  ResendOtpParams({required this.phone});

  @override
  Map<String, dynamic> get toMap => {'mobile': phone};
}
