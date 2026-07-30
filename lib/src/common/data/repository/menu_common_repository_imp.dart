import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core.dart';
import '../../../authentication/data/models/api_user_model.dart';
import '../../domain/entity/menu/contact_us_entity.dart';
import '../../domain/entity/menu/static_page_type_enum.dart';
import '../../domain/repository/menu_common_repository.dart';
import '../../domain/use_cases/menu/send_contact_us_message_use_case.dart';

@Injectable(as: MenuCommonRepository)
class MenuCommonRepositoryImp implements MenuCommonRepository {
  final DioHelper _apiHelper;
  final SecureStorageRepository _secureStorage;

  MenuCommonRepositoryImp(this._apiHelper, this._secureStorage);

  @override
  DomainServiceType<String> getStaticPageData(StaticPageTypeEnum type) async {
    return await failureCollect<String>(() async {
      final result = await _apiHelper.get(url: "/shared-api/v1/static-pages/${type.key}");
      final String data;
      switch (type) {
        case StaticPageTypeEnum.aboutUs:
          data = result['data'] ?? '';
        case StaticPageTypeEnum.termsAndConditions:
          data = result['data'] ?? '';

        case StaticPageTypeEnum.privacyPolicy:
          data = result['data'] ?? '';
      }

      return Right(data);
    });
  }

  @override
  DomainServiceType<ContactUsEntity> getContactUsData() async {
    return await failureCollect<ContactUsEntity>(() async {
      final result = await _apiHelper.get(url: "/shared-api/v1/static-pages/app-contacts");
      final data = result['data'];
      return Right(ContactUsEntity.fromJson(data));
    });
  }

  @override
  DomainServiceType<void> sendContactUsMessage(SendContactUsMessageParams params) async {
    return await failureCollect<void>(() async {
      await _apiHelper.post(url: "/shared-api/v1/contacts", body: params.toMap);
      return const Right(null);
    });
  }

  // @override
  // DomainServiceType<List<FaqEntity>> getFaqList() async {
  //   return await failureCollect<List<FaqEntity>>(() async {
  //     final req = await _apiHelper.get(url: "static-pages/common-questions");
  //     final reqData = req['data'] as List;
  //     final List<FaqEntity> data = reqData.map((e) => FaqEntity.fromJson(e)).toList();
  //     return Right(data);
  //   });
  // }

  @override
  DomainServiceType<void> toggleNotificationEnable() async {
    return await failureCollect<void>(() async {
      final result = await _apiHelper.post(url: "auth/toggle-notification");
      final userJson = result['data']['user'];
      final user = ApiUserModel.fromJson(userJson);
      await _secureStorage.setCachedUser(user.map.mapToCacheEntity);
      return const Right(null);
    });
  }
}
